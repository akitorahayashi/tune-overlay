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

  func testApplyToneOverlayWithVeilIncreasesBlendFactor() {
    let node = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
    let style = ToneOverlayStyle(
      desaturation: 0.5,
      dim: 0.0,
      contrast: 1.0,
      veilOpacity: 0.3
    )

    node.applyToneOverlay(style: style)

    // colorBlendFactor should combine desaturation and veil
    XCTAssertEqual(node.colorBlendFactor, 0.8, accuracy: 0.01, "Blend factor should combine effects")
  }

  func testApplyToneOverlayPreservesOriginalAlpha() {
    let node = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
    node.alpha = 0.5

    let style = ToneOverlayStyle(desaturation: 0.5, dim: 0.2, contrast: 1.0)

    node.applyToneOverlay(style: style)
    node.removeToneOverlay()

    XCTAssertEqual(node.alpha, 0.5, accuracy: 0.01, "Original alpha should be restored")
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
