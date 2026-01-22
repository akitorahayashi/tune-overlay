import SpriteKit
import SwiftUI
import XCTest

@testable import ToneOverlay

@MainActor
final class SKSpriteNodeToneOverlayTests: XCTestCase {
  // MARK: - Overlay Application Tests

  func testApplyToneOverlaySetsColorBlendFactor() {
    let node = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 100))
    let style = ToneOverlayStyle(desaturation: 0.8, dim: 0.2, contrast: 0.9)

    node.applyToneOverlay(style: style)

    XCTAssertEqual(node.colorBlendFactor, 0.8, accuracy: 0.01, "Color blend factor should match desaturation")
    // Color should be some form of gray (RGB components equal)
    #if canImport(UIKit)
      var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
      node.color.getRed(&r, green: &g, blue: &b, alpha: &a)
      XCTAssertEqual(r, g, accuracy: 0.01, "Color should be gray")
      XCTAssertEqual(g, b, accuracy: 0.01, "Color should be gray")
    #endif
  }

  func testApplyToneOverlayReducesAlphaForDimming() {
    let node = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 100))
    let style = ToneOverlayStyle(desaturation: 0.0, dim: 0.3, contrast: 1.0)

    node.applyToneOverlay(style: style)

    // Alpha should be reduced by dim amount (1.0 - 0.3 = 0.7)
    XCTAssertEqual(node.alpha, 0.7, accuracy: 0.01, "Alpha should be reduced for dimming")
  }

  func testRemoveToneOverlayRestoresDefaults() {
    let node = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 100))
    let style = ToneOverlayStyle(desaturation: 1.0, dim: 0.2, contrast: 0.9)

    // Apply then remove
    node.applyToneOverlay(style: style)
    node.removeToneOverlay()

    XCTAssertEqual(node.colorBlendFactor, 0, "Color blend factor should be reset")
    XCTAssertEqual(node.alpha, 1.0, accuracy: 0.01, "Alpha should be restored")
  }

  func testApplyToneOverlayWithVeilAddsOverlayChild() {
    let node = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
    let style = ToneOverlayStyle(
      desaturation: 0.5,
      dim: 0.0,
      contrast: 1.0,
      veilOpacity: 0.3
    )

    node.applyToneOverlay(style: style)

    let overlayChild = node.childNode(withName: "ToneOverlayEffectNode")
    XCTAssertNotNil(overlayChild, "Overlay child should be added for veil effect")
  }

  func testRemoveToneOverlayRemovesOverlayChild() {
    let node = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
    let style = ToneOverlayStyle(
      desaturation: 0.5,
      dim: 0.0,
      contrast: 1.0,
      veilOpacity: 0.3
    )

    node.applyToneOverlay(style: style)
    node.removeToneOverlay()

    let overlayChild = node.childNode(withName: "ToneOverlayEffectNode")
    XCTAssertNil(overlayChild, "Overlay child should be removed")
  }

  // MARK: - Color Extraction Tests

  func testColorRGBAComponentsExtractsBlack() {
    let color = Color.black
    let components = color.rgbaComponents

    XCTAssertEqual(components.red, 0.0, accuracy: 0.01)
    XCTAssertEqual(components.green, 0.0, accuracy: 0.01)
    XCTAssertEqual(components.blue, 0.0, accuracy: 0.01)
  }

  func testColorRGBAComponentsExtractsWhite() {
    let color = Color.white
    let components = color.rgbaComponents

    XCTAssertEqual(components.red, 1.0, accuracy: 0.01)
    XCTAssertEqual(components.green, 1.0, accuracy: 0.01)
    XCTAssertEqual(components.blue, 1.0, accuracy: 0.01)
  }

  func testColorRGBAComponentsExtractsRGBColor() {
    // Use explicit RGB values to avoid system color space variations
    let color = Color(red: 0.5, green: 0.25, blue: 0.75)
    let components = color.rgbaComponents

    XCTAssertEqual(components.red, 0.5, accuracy: 0.05)
    XCTAssertEqual(components.green, 0.25, accuracy: 0.05)
    XCTAssertEqual(components.blue, 0.75, accuracy: 0.05)
  }
}
