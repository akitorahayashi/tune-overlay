# Swift Package Template Overview

This repository, `sft-pkg-tmpl`, provides a clean Swift Package Manager template that teams can extend when bootstrapping a new library. It offers a lightweight implementation target named `TemplatePackage`, along with ready-to-run unit and integration test suites, CI workflows, and documentation scaffolding.

## 1. Project Summary

- **Library Target**: `TemplatePackage`
- **Unit Tests**: `TemplatePackageUnitTests`
- **Integration Tests**: `TemplatePackageIntgTests`
- **Tooling**: `just` recipes for setup, linting, testing, and maintenance.

The goal is to give maintainers a production-ready skeleton that can be adapted to any domain without carrying over Asterism-specific concepts.

## 2. Tech Stack

- **Language**: Swift
- **Package Manager**: Swift Package Manager (SPM)
- **Dependencies**: None by default; add project-specific dependencies as needed.

## 3. Coding Standards

Code quality is maintained through SwiftFormat for formatting and SwiftLint for linting.

### Formatter: SwiftFormat

- Configuration lives in `.swiftformat`.
- Indentation: 4 spaces.
- Line Width: Maximum 120 characters.
- Brace Style: K&R (opening brace on the same line).
- Semicolons: Prohibited.
- `self`: Required for property and method access.
- Imports: Grouped and sorted alphabetically.

### Linter: SwiftLint

- Configuration lives in `.swiftlint.yml`.
- Key enabled rules include `explicit_self`, `unused_declaration`, `unused_import`, `empty_count`, and `first_where`.
- Complexity limits: cyclomatic complexity warning at 10 (error at 20); file length warning at 600 lines (error at 1000).

## 4. Naming Conventions

- **Types**: `PascalCase` (e.g., `TemplatePackage`).
- **Functions & Methods**: `camelCase` (e.g., `runCommand`).
- **Variables & Properties**: `camelCase` (e.g., `baseURL`).
- **Test Methods**: `camelCase`, prefixed with `test`.

## 5. Key Commands

`just` automates the most common tasks:

- `just setup`: Initialize the project, create `.env`, and install tools via Mint.
- `just format`: Format the codebase with SwiftFormat.
- `just lint`: Run SwiftFormat in lint mode and SwiftLint.
- `just unit-test`: Run `TemplatePackageUnitTests`.
- `just intg-test`: Run `TemplatePackageIntgTests`.
- `just test`: Execute all tests.
- `just clean`: Remove build artifacts.

## 6. Testing Strategy

- **Framework**: XCTest (via SPM).
- **Unit Tests**: Located in `Tests/TemplatePackageUnitTests`; keep them focused on isolated functionality.
- **Integration Tests**: Located in `Tests/TemplatePackageIntgTests`; intended for multi-component or live-service scenarios.
- **CI**: GitHub Actions workflows in `.github/workflows` run linting and the test suites using the reusable `run-linters` and `run-tests` workflows.
