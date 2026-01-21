import SwiftUI

public extension View {
  func toneOverlay(isLocked: Bool, style: ToneOverlayStyle) -> some View {
    self.modifier(ToneOverlayModifier(isLocked: isLocked, style: style))
  }
}

private struct ToneOverlayModifier: ViewModifier {
  let isLocked: Bool
  let style: ToneOverlayStyle

  @ViewBuilder
  func body(content: Content) -> some View {
    if self.isLocked {
      content
        .saturation(self.saturationAmount)
        .brightness(-self.style.dim)
        .contrast(self.style.contrast)
        .overlay(self.overlayView.mask(content))
    } else {
      content
    }
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
