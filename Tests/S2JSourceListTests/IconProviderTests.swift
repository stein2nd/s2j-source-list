//
//  IconProviderTests.swift
//  S2JSourceListTests
//

@testable import S2JSourceList
import XCTest

final class IconProviderTests: XCTestCase {
    func testSystemSymbolImage() {
        XCTAssertNotNil(IconProvider.image(for: "folder"))
    }

    func testNilForEmptyName() {
        XCTAssertNil(IconProvider.image(for: nil))
        XCTAssertNil(IconProvider.image(for: ""))
    }

    func testDefaultIconFallback() {
        let image = IconProvider.image(for: "not-a-real-icon-name", defaultIcon: "doc")
        XCTAssertNotNil(image)
    }

    #if os(macOS)
        func testNSImageSystemSymbol() {
            XCTAssertNotNil(IconProvider.nsImage(for: "folder"))
            XCTAssertNil(IconProvider.nsImage(for: ""))
        }
    #endif
}
