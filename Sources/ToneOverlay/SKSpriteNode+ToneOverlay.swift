import SpriteKit
import SwiftUI

extension SKSpriteNode {
  // Precompiled base shader for performance - copying is cheaper than recompiling
  private static let baseToneOverlayShader = SKShader(source: toneOverlayShaderSource)

  /// Applies a tone overlay effect to the sprite node.
  ///
  /// The shader applies desaturation, dimming, contrast adjustment,
  /// tinting, and veil effects matching the SwiftUI `toneOverlay` modifier.
  ///
  /// - Parameter style: The visual style configuration for the overlay effect.
  public func applyToneOverlay(style: ToneOverlayStyle) {
    // swiftlint:disable:next force_cast
    let shader = Self.baseToneOverlayShader.copy() as! SKShader
    shader.uniforms = Self.uniforms(for: style)
    self.shader = shader
  }

  /// Removes the tone overlay effect from the sprite node.
  public func removeToneOverlay() {
    self.shader = nil
  }

  private static func uniforms(for style: ToneOverlayStyle) -> [SKUniform] {
    let tintComponents = style.tint.rgbaComponents

    return [
      SKUniform(name: "u_desaturation", float: Float(style.desaturation)),
      SKUniform(name: "u_dim", float: Float(style.dim)),
      SKUniform(name: "u_contrast", float: Float(style.contrast)),
      SKUniform(name: "u_tintR", float: Float(tintComponents.red)),
      SKUniform(name: "u_tintG", float: Float(tintComponents.green)),
      SKUniform(name: "u_tintB", float: Float(tintComponents.blue)),
      SKUniform(name: "u_tintOpacity", float: Float(style.tintOpacity)),
      SKUniform(name: "u_veilOpacity", float: Float(style.veilOpacity)),
    ]
  }

  // MARK: - Shader Source

  private static let toneOverlayShaderSource = """
  void main() {
    // Sample the texture
    vec4 color = texture2D(u_texture, v_tex_coord);

    // Skip fully transparent pixels
    if (color.a < 0.001) {
      gl_FragColor = color;
      return;
    }

    // Unpremultiply alpha for proper color manipulation
    vec3 rgb = color.rgb / color.a;

    // 1. Desaturation: blend toward grayscale
    float gray = dot(rgb, vec3(0.2126, 0.7152, 0.0722));
    rgb = mix(rgb, vec3(gray), u_desaturation);

    // 2. Dimming: reduce brightness
    rgb = rgb - u_dim;

    // 3. Contrast adjustment: scale around midpoint (0.5)
    rgb = (rgb - 0.5) * u_contrast + 0.5;

    // 4. Tint overlay: blend with tint color
    vec3 tint = vec3(u_tintR, u_tintG, u_tintB);
    rgb = mix(rgb, tint, u_tintOpacity);

    // 5. Veil overlay: blend with black
    rgb = mix(rgb, vec3(0.0), u_veilOpacity);

    // Clamp and re-premultiply alpha
    rgb = clamp(rgb, 0.0, 1.0) * color.a;

    gl_FragColor = vec4(rgb, color.a);
  }
  """
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
