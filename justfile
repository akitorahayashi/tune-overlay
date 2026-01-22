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
rel-pkg cache_path=SWIFTPM_DEP_CACHE reset="false":
    @echo "Using dependency cache at: {{cache_path}}"
    @mkdir -p "{{cache_path}}"
    @echo "🔄 Resolving dependencies for {{PACKAGE_NAME}}..."
    @swift package resolve --cache-path "{{cache_path}}"
    @echo "✅ Package resolution complete."

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

pkg-test *args:
    @swift test --parallel {{args}}

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
