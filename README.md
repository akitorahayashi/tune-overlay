# Swift Package Template (`sft-pkg-tmpl`)

`sft-pkg-tmpl` is a lightweight Swift Package Manager template that provides a starting point for building new libraries. It ships with a minimal implementation target (`TemplatePackage`), unit and integration test targets, ready-to-use GitHub Actions workflows, and convenience scripts powered by `just`.

## Installation

Add the package as a dependency in your `Package.swift`:

```swift
let package = Package(
    name: "YourApp",
    dependencies: [
        .package(url: "https://github.com/your-org/sft-pkg-tmpl", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "YourApp",
            dependencies: [
                .product(name: "TemplatePackage", package: "sft-pkg-tmpl")
            ]
        )
    ]
)
```

## Quick Start

Import the library and use the starter API:

```swift
import TemplatePackage

let sut = TemplatePackage()
print(sut.hello()) // "Hello from TemplatePackage"
```

Use the provided `.env.example` to document any environment variables your downstream package might need. Copy it into `.env` during setup:

```bash
cp .env.example .env
```

## Development

This template relies on [`just`](https://github.com/casey/just) for common tasks. Run `just --list` to see the available recipes. Key commands include:

- `just setup` – bootstrap the repository and install tooling via Mint.
- `just lint` – run SwiftFormat in lint mode and SwiftLint.
- `just unit-test` – execute `TemplatePackageUnitTests`.
- `just intg-test` – execute `TemplatePackageIntgTests`.
- `just test` – run the full test suite.

Feel free to expand or replace the placeholder implementation with your domain-specific logic. The documentation under `docs/` highlights how to adapt configuration, testing, and contribution guidelines for your project.
