// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "tone-overlay",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
  ],
  products: [
    .library(
      name: "ToneOverlay",
      targets: ["ToneOverlay"]
    ),
    .library(
      name: "ToneOverlayExamples",
      targets: ["ToneOverlayExamples"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "ToneOverlay"
    ),
    .target(
      name: "ToneOverlayExamples",
      dependencies: ["ToneOverlay"],
      path: "Examples/ToneOverlayExamples",
      resources: [
        .process("Resources"),
      ]
    ),
    .testTarget(
      name: "ToneOverlayTests",
      dependencies: ["ToneOverlay"]
    ),
  ]
)
