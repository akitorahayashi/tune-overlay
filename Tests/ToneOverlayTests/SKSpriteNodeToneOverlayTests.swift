import SpriteKit
import SwiftUI
import XCTest

@testable import ToneOverlay

@MainActor
final class SKSpriteNodeToneOverlayTests: XCTestCase {
  // MARK: - Shader Application Tests

  func testApplyToneOverlaySetsShader() {
    let node = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 100))
    let style = ToneOverlayStyle(desaturation: 1.0, dim: 0.2, contrast: 0.9)

    node.applyToneOverlay(style: style)

    XCTAssertNotNil(node.shader, "Shader should be set when overlay is applied")
  }

  func testRemoveToneOverlayClearsShader() {
    let node = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 100))
    let style = ToneOverlayStyle(desaturation: 1.0, dim: 0.2, contrast: 0.9)

    // First apply it
    node.applyToneOverlay(style: style)
    XCTAssertNotNil(node.shader)

    // Then remove
    node.removeToneOverlay()
    XCTAssertNil(node.shader, "Shader should be nil after removing overlay")
  }

  func testApplyToneOverlayShaderHasExpectedUniforms() {
    let node = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
    let style = ToneOverlayStyle(
      desaturation: 0.8,
      dim: 0.15,
      contrast: 0.85,
      tint: .red,
      tintOpacity: 0.1,
      veilOpacity: 0.05
    )

    node.applyToneOverlay(style: style)

    guard let shader = node.shader else {
      XCTFail("Expected shader to be set")
      return
    }

    let uniformNames = shader.uniforms.map(\.name)
    XCTAssertTrue(uniformNames.contains("u_desaturation"))
    XCTAssertTrue(uniformNames.contains("u_dim"))
    XCTAssertTrue(uniformNames.contains("u_contrast"))
    XCTAssertTrue(uniformNames.contains("u_tintR"))
    XCTAssertTrue(uniformNames.contains("u_tintG"))
    XCTAssertTrue(uniformNames.contains("u_tintB"))
    XCTAssertTrue(uniformNames.contains("u_tintOpacity"))
    XCTAssertTrue(uniformNames.contains("u_veilOpacity"))
  }

  func testApplyToneOverlayUniformValuesMatchStyle() {
    let node = SKSpriteNode(color: .green, size: CGSize(width: 50, height: 50))
    let style = ToneOverlayStyle(
      desaturation: 0.6,
      dim: 0.25,
      contrast: 0.7
    )

    node.applyToneOverlay(style: style)

    guard let shader = node.shader else {
      XCTFail("Expected shader to be set")
      return
    }

    let desatUniform = shader.uniforms.first { $0.name == "u_desaturation" }
    let dimUniform = shader.uniforms.first { $0.name == "u_dim" }
    let contrastUniform = shader.uniforms.first { $0.name == "u_contrast" }

    XCTAssertEqual(Double(desatUniform?.floatValue ?? 0), 0.6, accuracy: 0.0001)
    XCTAssertEqual(Double(dimUniform?.floatValue ?? 0), 0.25, accuracy: 0.0001)
    XCTAssertEqual(Double(contrastUniform?.floatValue ?? 0), 0.7, accuracy: 0.0001)
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
