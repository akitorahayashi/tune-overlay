# ToneOverlay

ToneOverlay is a SwiftUI package that applies customizable tone adjustments and overlays while preserving
transparency. The package ships with a `toneOverlay` view modifier and a configurable style model.

## Requirements

- iOS 16 or later
- macOS 13 or later
- Swift 6

## Package Usage

The package is added as a dependency in `Package.swift`:

```swift
let package = Package(
    name: "YourApp",
    dependencies: [
        .package(url: "https://github.com/your-org/tone-overlay", from: "0.1.0")
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

The library is imported and the modifier is applied in SwiftUI with explicit style values:

```swift
import ToneOverlay
import SwiftUI

let style = ToneOverlayStyle(
    desaturation: 0.6,
    dim: 0.18,
    contrast: 0.9,
    tint: .black,
    tintOpacity: 0.12,
    veilOpacity: 0.08
)

Image("red_ball")
    .toneOverlay(style: style)
```

## Style parameters

- desaturation reduces color intensity
- dim darkens the content
- contrast controls contrast
- tint and tintOpacity apply a color overlay
- veilOpacity applies a soft veil

## Tint only example

```swift
let alertStyle = ToneOverlayStyle.tinted(
    color: .red,
    opacity: 0.35,
    desaturation: 0.0,
    dim: 0.0,
    contrast: 1.0
)

Image("enemy_icon")
    .toneOverlay(style: alertStyle)
```

## Animation

The transition between active and inactive states can be animated using standard SwiftUI animation modifiers:

```swift
// Example 1: Using `withAnimation` for implicit animation.
// Assumes `isActive` is a @State var.
VStack {
    Image("icon")
        .toneOverlay(isActive: isActive, style: style)
    Button("Toggle") {
        withAnimation { isActive.toggle() }
    }
}

// Example 2: Using the `.animation()` modifier for explicit animation.
Image("icon")
    .toneOverlay(isActive: isActive, style: style)
    .animation(.easeInOut, value: isActive)
```

## Development

Project automation is provided via [`just`](https://github.com/casey/just), and the main recipes include:

- `just setup` – tool bootstrap via Mint.
- `just check` – SwiftFormat lint mode plus SwiftLint.
- `just test` – full test suite.
