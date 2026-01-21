# ==============================================================================
# justfile for ToneOverlay automation
# ==============================================================================

# --- PROJECT SETTINGS ---
PACKAGE_NAME := "tone-overlay"

# --- SWIFT PACKAGE OPTIONS ---
HOME_DIR := env("HOME")
SWIFTPM_ROOT := env("SWIFTPM_ROOT", HOME_DIR + "/.cache/swiftpm/tone-overlay")
SWIFTPM_DEP_CACHE := SWIFTPM_ROOT + "/dependencies"
SWIFTPM_ARTIFACT_ROOT := SWIFTPM_ROOT + "/artifacts"

# ==============================================================================
# Main
# ==============================================================================

# default recipe
default: help

# Show available recipes
help:
    @echo "Usage: just [recipe]"
    @echo "Available recipes:"
    @just --list | tail -n +2 | awk '{printf "  \033[36m%-30s\033[0m %s\n", $1, substr($0, index($0, $2))}'

# ==============================================================================
# Environment Setup
# ==============================================================================

# Initialize project: install dependencies
setup:
    @echo "Bootstrapping Mint packages..."
    @mint bootstrap
    @echo "✅ Project setup complete."

# Resolve Swift package dependencies
resolve-packages cache_path=SWIFTPM_DEP_CACHE:
    #!/usr/bin/env bash
    set -e
    echo "Using dependency cache at: {{cache_path}}"
    mkdir -p "{{cache_path}}"
    echo "🔄 Resolving dependencies for {{PACKAGE_NAME}}..."
    swift package resolve --cache-path "{{cache_path}}"
    echo "✅ Package resolution complete."

# Reset SwiftPM cache, dependencies, and build artifacts
resolve-pkg:
    @echo "Removing SwiftPM build and cache..."
    @rm -rf .build
    @rm -rf {{SWIFTPM_ROOT}}
    @echo "✅ SwiftPM build and cache removed."
    @echo "Resolving Swift package dependencies..."
    @just resolve-packages
    @echo "✅ Package dependencies resolved."

# ==============================================================================
# Lint & Format
# ==============================================================================

# Format code
fix:
    @mint run swiftformat .
    @mint run swiftlint lint --fix .

# Check code format
check: fix
    @mint run swiftformat --lint .
    @mint run swiftlint lint --strict

# ==============================================================================
# Testing
# ==============================================================================

# Usage: just pkg-test [filter] [ci] [extra_args]
# filter: Optional regex to filter tests (e.g., "ToneOverlayTests")
# ci: Optional CI mode flag ("true" limits workers to 1)
# extra_args: Additional arguments passed to swift test (e.g. "--skip-build")
pkg-test filter="" ci="false" *extra_args:
    #!/usr/bin/env bash
    set -e
    mkdir -p {{SWIFTPM_DEP_CACHE}}
    mkdir -p {{SWIFTPM_ARTIFACT_ROOT}}
    echo "🧪 Testing {{PACKAGE_NAME}}..."
    
    ARGS_ARRAY=()
    for arg in {{extra_args}}; do
        ARGS_ARRAY+=("$arg")
    done
    
    if [ -n "{{filter}}" ];
    then
        ARGS_ARRAY+=(--filter "{{filter}}")
        echo "📋 Filtering tests with: {{filter}}"
    else
        echo "📋 Running all tests"
    fi
    
    if [ "{{ci}}" = "true" ];
    then
        echo "🔧 CI Mode: Running with 1 worker to save resources..."
        ARGS_ARRAY+=(--parallel --num-workers 1)
    else
        echo "🚀 Local Mode: Running in parallel..."
        WORKERS=$(sysctl -n hw.ncpu)
        ARGS_ARRAY+=(--parallel --num-workers "$WORKERS")
    fi
    
    echo "Running: swift test ${ARGS_ARRAY[@]}"
    swift test --cache-path "{{SWIFTPM_DEP_CACHE}}" \
               --scratch-path "{{SWIFTPM_ARTIFACT_ROOT}}" \
               "${ARGS_ARRAY[@]}"
    echo "✅ Tests complete."

# Run all tests
test:
    @just pkg-test

# ==============================================================================
# CLEANUP
# ==============================================================================

# Clean build artifacts, caches, and generated files
clean:
    @rm -rf .build
    @rm -rf {{SWIFTPM_ROOT}}
