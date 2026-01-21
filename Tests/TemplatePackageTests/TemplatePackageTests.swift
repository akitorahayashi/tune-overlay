@testable import TemplatePackage
import XCTest

final class TemplatePackageTests: XCTestCase {
  func testHelloReturnsGreeting() {
    let sut = TemplatePackage()
    XCTAssertEqual(sut.hello(), "Hello from TemplatePackage")
  }
}
