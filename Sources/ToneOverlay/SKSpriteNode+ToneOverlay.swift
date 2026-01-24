import SpriteKit
import SwiftUI

public extension SKSpriteNode {
  /// Storage key for original alpha value
  private static var originalAlphaKey: UInt8 = 0

  /// Applies a tone overlay effect to the sprite node.
  ///
  /// This implementation uses SpriteKit's built-in colorBlendFactor
  /// to achieve desaturation and darkening effects while respecting
  /// the sprite's transparent regions.
  ///
  /// - Parameter style: The visual style configuration for the overlay effect.
  func applyToneOverlay(style: ToneOverlayStyle) {
    // Store original alpha if not already stored
    if objc_getAssociatedObject(self, &Self.originalAlphaKey) == nil {
      objc_setAssociatedObject(self, &Self.originalAlphaKey, self.alpha, .OBJC_ASSOCIATION_RETAIN)
    }

    // Calculate the effective darkening color
    // Combine desaturation (gray), veil (black), and tint into a single blend color
    let tintComponents = style.tint.rgbaComponents

    // Weight factors for combining effects
    let veilWeight = style.veilOpacity
    let tintWeight = style.tintOpacity * (1.0 - veilWeight)
    let grayWeight = style.desaturation * (1.0 - veilWeight - tintWeight)

    // Blend colors: veil (black) + tint + gray
    let r = tintComponents.red * tintWeight + 0.5 * grayWeight
    let g = tintComponents.green * tintWeight + 0.5 * grayWeight
    let b = tintComponents.blue * tintWeight + 0.5 * grayWeight

    #if canImport(UIKit)
      self.color = UIColor(red: r, green: g, blue: b, alpha: 1.0)
    #else
      self.color = NSColor(red: r, green: g, blue: b, alpha: 1.0)
    #endif

    // colorBlendFactor controls how much the color replaces the original texture
    // Higher values = more of the blend color, less of the original
    let totalBlend = min(1.0, style.desaturation + style.veilOpacity + style.tintOpacity)
    self.colorBlendFactor = CGFloat(totalBlend)

    // Apply dimming via alpha reduction
    let dimAlpha = max(0.2, 1.0 - style.dim)
    self.alpha = CGFloat(dimAlpha)
  }

  /// Removes the tone overlay effect from the sprite node.
  func removeToneOverlay() {
    self.colorBlendFactor = 0
    self.color = .white

    // Restore original alpha
    if let originalAlpha = objc_getAssociatedObject(self, &Self.originalAlphaKey) as? CGFloat {
      self.alpha = originalAlpha
      objc_setAssociatedObject(self, &Self.originalAlphaKey, nil, .OBJC_ASSOCIATION_RETAIN)
    } else {
      self.alpha = 1.0
    }
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
