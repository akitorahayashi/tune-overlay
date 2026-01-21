import SwiftUI
import ToneOverlay

#if canImport(AppKit)
  import AppKit
#endif

#if canImport(UIKit)
  import UIKit
#endif

#if canImport(UIKit)
  private typealias ToneOverlayPlatformImage = UIImage
#elseif canImport(AppKit)
  private typealias ToneOverlayPlatformImage = NSImage
#endif

@available(iOS 16.0, macOS 13.0, *)
struct ToneOverlayPreview: PreviewProvider {
  static var previews: some View {
    ToneOverlayPreviewContent()
      .padding(24)
      .previewLayout(.sizeThatFits)
  }
}

private struct ToneOverlayPreviewContent: View {
  private let imageName = "yellow_ball"

  private var rows: [ToneOverlayPreviewRow] {
    [
      ToneOverlayPreviewRow(title: "Original", style: nil),
      ToneOverlayPreviewRow(
        title: "Tint only",
        style: ToneOverlayStyle(
          desaturation: 0.0,
          dim: 0.0,
          contrast: 1.0,
          tint: .red,
          tintOpacity: 0.35,
          veilOpacity: 0.0
        )
      ),
      ToneOverlayPreviewRow(
        title: "Desaturation only",
        style: ToneOverlayStyle(
          desaturation: 0.7,
          dim: 0.0,
          contrast: 1.0,
          tint: .black,
          tintOpacity: 0.0,
          veilOpacity: 0.0
        )
      ),
      ToneOverlayPreviewRow(
        title: "Dim only",
        style: ToneOverlayStyle(
          desaturation: 0.0,
          dim: 0.2,
          contrast: 1.0,
          tint: .black,
          tintOpacity: 0.0,
          veilOpacity: 0.0
        )
      ),
      ToneOverlayPreviewRow(
        title: "Contrast down",
        style: ToneOverlayStyle(
          desaturation: 0.0,
          dim: 0.0,
          contrast: 0.8,
          tint: .black,
          tintOpacity: 0.0,
          veilOpacity: 0.0
        )
      ),
      ToneOverlayPreviewRow(
        title: "Veil only",
        style: ToneOverlayStyle(
          desaturation: 0.0,
          dim: 0.0,
          contrast: 1.0,
          tint: .black,
          tintOpacity: 0.0,
          veilOpacity: 0.2
        )
      ),
      ToneOverlayPreviewRow(
        title: "Combined effects",
        style: ToneOverlayStyle(
          desaturation: 0.6,
          dim: 0.18,
          contrast: 0.9,
          tint: .black,
          tintOpacity: 0.12,
          veilOpacity: 0.08
        )
      ),
    ]
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text("ToneOverlay preview")
        .font(.headline)

      Text("Each row shows one parameter across image text and shape")
        .font(.subheadline)
        .foregroundStyle(.secondary)

      ToneOverlayPreviewGrid(imageName: self.imageName, rows: self.rows)
    }
  }
}

private struct ToneOverlayPreviewGrid: View {
  let imageName: String
  let rows: [ToneOverlayPreviewRow]

  private let labelWidth: CGFloat = 140
  private let cellWidth: CGFloat = 100

  var body: some View {
    Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 12) {
      GridRow {
        Color.clear
          .frame(width: self.labelWidth, height: 0)
        self.headerCell("Image")
        self.headerCell("Text")
        self.headerCell("Shape")
      }

      ForEach(self.rows) { row in
        GridRow {
          Text(row.title)
            .font(.subheadline)
            .frame(width: self.labelWidth, alignment: .leading)
            .lineLimit(2)
          ToneOverlayPreviewCell(
            title: row.title,
            imageName: self.imageName,
            style: row.style
          )
          .frame(width: self.cellWidth)
          ToneOverlayTextCell(title: row.title, style: row.style)
            .frame(width: self.cellWidth)
          ToneOverlayShapeCell(title: row.title, style: row.style)
            .frame(width: self.cellWidth)
        }
      }
    }
  }

  private func headerCell(_ title: String) -> some View {
    Text(title)
      .font(.caption)
      .foregroundStyle(.secondary)
      .frame(width: self.cellWidth, alignment: .leading)
  }
}

private struct ToneOverlayPreviewRow: Identifiable {
  let id = UUID()
  let title: String
  let style: ToneOverlayStyle?
}

private struct ToneOverlayPreviewCell: View {
  let title: String
  let imageName: String
  let style: ToneOverlayStyle?

  var body: some View {
    self.previewImage
      .frame(width: 80, height: 80)
  }

  @ViewBuilder
  private var previewImage: some View {
    if let platformImage = self.platformImage {
      let base = self.imageView(for: platformImage)
        .resizable()
        .scaledToFit()

      if let style = self.style {
        base.toneOverlay(style: style)
      } else {
        base
      }
    } else {
      Color.black.opacity(0.08)
        .overlay(Text("Missing").font(.caption2))
    }
  }

  private var platformImage: ToneOverlayPlatformImage? {
    guard let url = Bundle.module.url(forResource: self.imageName, withExtension: "png") else {
      return nil
    }

    #if canImport(UIKit)
      return UIImage(contentsOfFile: url.path)
    #elseif canImport(AppKit)
      return NSImage(contentsOf: url)
    #else
      return nil
    #endif
  }

  private func imageView(for image: ToneOverlayPlatformImage) -> Image {
    #if canImport(UIKit)
      Image(uiImage: image)
    #elseif canImport(AppKit)
      Image(nsImage: image)
    #else
      Image(systemName: "questionmark")
    #endif
  }
}

private struct ToneOverlayTextCell: View {
  let title: String
  let style: ToneOverlayStyle?

  var body: some View {
    self.previewText
      .frame(height: 80)
      .foregroundStyle(.cyan)
  }

  @ViewBuilder
  private var previewText: some View {
    let base = Text("BOSS")
      .font(.system(size: 24, weight: .black, design: .rounded))

    if let style = self.style {
      base.toneOverlay(style: style)
    } else {
      base
    }
  }
}

private struct ToneOverlayShapeCell: View {
  let title: String
  let style: ToneOverlayStyle?

  var body: some View {
    self.previewShape
      .frame(width: 80, height: 80)
  }

  @ViewBuilder
  private var previewShape: some View {
    let base = Circle()
      .fill(
        LinearGradient(
          colors: [.cyan, .blue],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
      )

    if let style = self.style {
      base.toneOverlay(style: style)
    } else {
      base
    }
  }
}
