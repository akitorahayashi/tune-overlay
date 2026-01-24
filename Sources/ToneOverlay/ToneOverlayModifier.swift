import SwiftUI

public extension View {
  /// Adds a tone overlay effect to the view when the overlay is active.
  /// - Parameters:
  ///   - isActive: A Boolean that controls whether the overlay is applied.
  ///   - style: The visual style configuration for the overlay effect.
  /// - Returns: A view that renders with the overlay when active.
  func toneOverlay(isActive: Bool = true, style: ToneOverlayStyle) -> some View {
    self.modifier(ToneOverlayModifier(isActive: isActive, style: style))
  }
}

private struct ToneOverlayModifier: ViewModifier {
  let isActive: Bool
  let style: ToneOverlayStyle

  @ViewBuilder
  func body(content: Content) -> some View {
    content
      .saturation(self.isActive ? self.saturationAmount : 1.0)
      .brightness(self.isActive ? -self.style.dim : 0.0)
      .contrast(self.isActive ? self.style.contrast : 1.0)
      .overlay(
        self.overlayView
          .opacity(self.isActive ? 1.0 : 0.0)
          .mask(content)
      )
  }

  private var saturationAmount: Double {
    max(0.0, 1.0 - self.style.desaturation)
  }

  @ViewBuilder
  private var overlayView: some View {
    ZStack {
      if self.style.tintOpacity > 0 {
        self.style.tint.opacity(self.style.tintOpacity)
      }
      if self.style.veilOpacity > 0 {
        Color.black.opacity(self.style.veilOpacity)
      }
    }
  }
}
