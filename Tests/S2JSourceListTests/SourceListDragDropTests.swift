//
//  SourceListDragDropTests.swift
//  S2JSourceListTests
//

@testable import S2JSourceList
import XCTest

final class SourceListDragDropTests: XCTestCase {
    func testPayloadRoundTrip() {
        let id = UUID()
        let payload = SourceListDragDrop.payload(for: id)
        XCTAssertEqual(SourceListDragDrop.parse(payload), id)
    }

    func testParseRejectsForeignStrings() {
        XCTAssertNil(SourceListDragDrop.parse("not-a-payload"))
    }
}