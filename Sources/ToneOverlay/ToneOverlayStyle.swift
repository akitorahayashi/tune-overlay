import SwiftUI

/// A configuration that defines tone overlay behavior for SwiftUI and SpriteKit.
public struct ToneOverlayStyle: Sendable {
  /// Amount of desaturation applied to the content, where 0 preserves color and 1 fully desaturates.
  public var desaturation: Double
  /// Amount of dimming applied to the content, where 0 preserves brightness and higher values darken.
  public var dim: Double
  /// Contrast multiplier applied to the content, where 1 preserves contrast.
  public var contrast: Double
  /// Tint color applied as an overlay.
  public var tint: Color
  /// Opacity of the tint overlay, from 0 to 1.
  public var tintOpacity: Double
  /// Opacity of the black veil overlay, from 0 to 1.
  public var veilOpacity: Double

  /// Initializes a tone overlay configuration.
  /// - Parameters:
  ///   - desaturation: Desaturation amount from 0 to 1.
  ///   - dim: Dimming amount, where higher values darken the content.
  ///   - contrast: Contrast multiplier, where 1 preserves contrast.
  ///   - tint: Tint color applied as an overlay.
  ///   - tintOpacity: Opacity of the tint overlay, from 0 to 1.
  ///   - veilOpacity: Opacity of the black veil overlay, from 0 to 1.
  public init(
    desaturation: Double,
    dim: Double,
    contrast: Double,
    tint: Color = .black,
    tintOpacity: Double = 0.0,
    veilOpacity: Double = 0.0
  ) {
    self.desaturation = desaturation
    self.dim = dim
    self.contrast = contrast
    self.tint = tint
    self.tintOpacity = tintOpacity
    self.veilOpacity = veilOpacity
  }
}
