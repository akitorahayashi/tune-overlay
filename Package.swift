// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "sft-pkg-tmpl",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
  ],
  products: [
    .library(
      name: "TemplatePackage",
      targets: ["TemplatePackage"]
    ),
  ],
  dependencies: [
    // Add third-party dependencies here when needed.
  ],
  targets: [
    .target(
      name: "TemplatePackage"
    ),
    .testTarget(
      name: "TemplatePackageTests",
      dependencies: ["TemplatePackage"]
    ),
  ]
)
