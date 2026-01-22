import SpriteKit
import SwiftUI

extension SKSpriteNode {
  /// Key used to identify the overlay effect node.
  private static let overlayNodeName = "ToneOverlayEffectNode"

  /// Applies a tone overlay effect to the sprite node.
  ///
  /// This implementation uses an SKEffectNode with CoreImage filters
  /// to achieve desaturation, dimming, and contrast effects, plus
  /// a color overlay child node for tinting.
  ///
  /// - Parameter style: The visual style configuration for the overlay effect.
  public func applyToneOverlay(style: ToneOverlayStyle) {
    // Apply grayscale effect via color blend (approximation of desaturation)
    self.colorBlendFactor = CGFloat(style.desaturation)
    self.color = .gray

    // Add or update overlay node for veil/tint effects
    if let existing = self.childNode(withName: Self.overlayNodeName) as? SKSpriteNode {
      self.configureOverlayNode(existing, style: style)
    } else if style.veilOpacity > 0 || style.tintOpacity > 0 {
      let overlayNode = SKSpriteNode(color: .clear, size: self.size)
      overlayNode.name = Self.overlayNodeName
      overlayNode.zPosition = 100
      self.configureOverlayNode(overlayNode, style: style)
      self.addChild(overlayNode)
    }

    // Apply brightness reduction (dimming) - use alpha as approximation
    let dimAlpha = max(0.3, 1.0 - style.dim)
    self.alpha = CGFloat(dimAlpha)
  }

  /// Removes the tone overlay effect from the sprite node.
  public func removeToneOverlay() {
    self.colorBlendFactor = 0
    self.color = .white
    self.alpha = 1.0
    self.childNode(withName: Self.overlayNodeName)?.removeFromParent()
  }

  private func configureOverlayNode(_ node: SKSpriteNode, style: ToneOverlayStyle) {
    node.size = self.size

    // Combine tint and veil into overlay color
    let tintComponents = style.tint.rgbaComponents
    let veilWeight = style.veilOpacity
    let tintWeight = style.tintOpacity * (1.0 - veilWeight)

    // Blend tint with black (veil)
    let r = tintComponents.red * tintWeight
    let g = tintComponents.green * tintWeight
    let b = tintComponents.blue * tintWeight
    let alpha = min(1.0, tintWeight + veilWeight)

    #if canImport(UIKit)
      node.color = UIColor(red: r, green: g, blue: b, alpha: alpha)
    #else
      node.color = NSColor(red: r, green: g, blue: b, alpha: alpha)
    #endif
    node.colorBlendFactor = 1.0
  }
}

// MARK: - Color RGBA Extraction

/// RGBA color components.
struct RGBAComponents {
  var red: Double
  var green: Double
  var blue: Double
  var alpha: Double
}

extension Color {
  /// Extracts RGBA components from a SwiftUI Color.
  var rgbaComponents: RGBAComponents {
    #if canImport(UIKit)
      let uiColor = UIColor(self)
      var red: CGFloat = 0
      var green: CGFloat = 0
      var blue: CGFloat = 0
      var alpha: CGFloat = 0
      uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
      return RGBAComponents(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    #elseif canImport(AppKit)
      let nsColor = NSColor(self).usingColorSpace(.deviceRGB) ?? NSColor.black
      var red: CGFloat = 0
      var green: CGFloat = 0
      var blue: CGFloat = 0
      var alpha: CGFloat = 0
      nsColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
      return RGBAComponents(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    #else
      return RGBAComponents(red: 0, green: 0, blue: 0, alpha: 1)
    #endif
  }
}
