//
//  SourceListKeyboardNavigationTests.swift
//  S2JSourceListTests
//

@testable import S2JSourceList
import XCTest

final class SourceListKeyboardNavigationTests: XCTestCase {
    func testNextSelectableIdMovesDown() {
        let id1 = UUID()
        let id2 = UUID()
        let ids = [id1, id2]
        XCTAssertEqual(
            SourceListKeyboardNavigation.nextSelectableId(selectableIds: ids, currentId: id1, offset: 1),
            id2
        )
    }

    func testNextSelectableIdAtEndReturnsNil() {
        let id1 = UUID()
        XCTAssertNil(SourceListKeyboardNavigation.nextSelectableId(selectableIds: [id1], currentId: id1, offset: 1))
    }

    func testShouldToggleExpansion() {
        let group = SourceItem.group(title: "G", children: [SourceItem(title: "C")])
        XCTAssertTrue(SourceListKeyboardNavigation.shouldToggleExpansion(item: group, isExpanded: false, expand: true))
        XCTAssertFalse(SourceListKeyboardNavigation.shouldToggleExpansion(item: group, isExpanded: true, expand: true))
    }

    func testContextItemUsesSelectionOrFirstOutlineRow() {
        let first = SourceItem(title: "First")
        let second = SourceItem(title: "Second")
        let outline = [first, second]

        XCTAssertEqual(SourceListKeyboardNavigation.contextItem(in: outline, selectedId: second.id)?.id, second.id)
        XCTAssertEqual(SourceListKeyboardNavigation.contextItem(in: outline, selectedId: nil)?.id, first.id)
        XCTAssertNil(SourceListKeyboardNavigation.contextItem(in: [], selectedId: nil))
    }
}
