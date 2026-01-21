import SwiftUI
import XCTest

@testable import ToneOverlay

final class ToneOverlayStyleTests: XCTestCase {
  func testInitializerAssignsAllProperties() {
    let style = ToneOverlayStyle(
      desaturation: 0.7,
      dim: 0.2,
      contrast: 0.95,
      tint: .green,
      tintOpacity: 0.15,
      veilOpacity: 0.1
    )

    XCTAssertEqual(style.desaturation, 0.7, accuracy: 0.0001)
    XCTAssertEqual(style.dim, 0.2, accuracy: 0.0001)
    XCTAssertEqual(style.contrast, 0.95, accuracy: 0.0001)
    XCTAssertEqual(style.tintOpacity, 0.15, accuracy: 0.0001)
    XCTAssertEqual(style.veilOpacity, 0.1, accuracy: 0.0001)
  }
}
