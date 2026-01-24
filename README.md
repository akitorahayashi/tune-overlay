# ToneOverlay

ToneOverlay is a Swift package that applies tone adjustments while preserving transparency.
The package supports both SwiftUI views and SpriteKit nodes via a shared `ToneOverlayStyle`.

## Requirements

- iOS 16 or later
- macOS 13 or later
- Swift 6

## Installation

The package is added as a dependency in `Package.swift`:

```swift
let package = Package(
    name: "YourApp",
    dependencies: [
        .package(url: "https://github.com/akitorahayashi/tone-overlay", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "YourApp",
            dependencies: [
                .product(name: "ToneOverlay", package: "tone-overlay")
            ]
        )
    ]
)
```

## Quick Start

The library is imported and the modifier is applied in SwiftUI:

```swift
import ToneOverlay
import SwiftUI

let style = ToneOverlayStyle(
    desaturation: 0.6,
    dim: 0.18,
    contrast: 0.9,
    tint: .black
)

Image("red_ball")
    .toneOverlay(style: style)
```

The same style configuration applies to SpriteKit nodes:

```swift
import ToneOverlay
import SpriteKit
import SwiftUI

let style = ToneOverlayStyle(
    desaturation: 1.0,
    dim: 0.2,
    contrast: 0.8,
    tint: Color.black,
    tintOpacity: 0.12,
    veilOpacity: 0.08
)

let sprite = SKSpriteNode(imageNamed: "planet")
sprite.applyToneOverlay(style: style)

// To remove the overlay effect:
sprite.removeToneOverlay()
```

## Documentation

- API reference and extended usage examples live in DocC and are published to GitHub Pages via `.github/workflows/publish-docc.yml`.
- Local DocC output is generated via:
  - `swift package generate-documentation --target ToneOverlay`

## Development

Project automation is provided via [`just`](https://github.com/casey/just), and the main recipes include:

- `just setup` – tool bootstrap via Mint.
- `just check` – SwiftFormat lint mode plus SwiftLint.
- `just test` – full test suite.
