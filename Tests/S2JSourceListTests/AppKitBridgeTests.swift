//
//  AppKitBridgeTests.swift
//  S2JSourceListTests
//

#if os(macOS)
@testable import S2JSourceList
import XCTest

final class AppKitBridgeTests: XCTestCase {
    func testBridgeColorsAreNonNil() {
        XCTAssertNotNil(AppKitBridge.accentColor)
        XCTAssertNotNil(AppKitBridge.windowBackgroundColor)
        XCTAssertNotNil(AppKitBridge.textColor)
        XCTAssertNotNil(AppKitBridge.secondaryTextColor)
    }
}
#endif