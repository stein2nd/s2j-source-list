//
//  SourceListOutlineTests.swift
//  S2JSourceListTests
//

@testable import S2JSourceList
import XCTest

final class SourceListOutlineTests: XCTestCase {
    func testVisibleItemsRespectsExpansion() {
        let leaf = SourceItem(title: "Leaf")
        let group = SourceItem.group(title: "Group", children: [leaf], isExpanded: false)

        let collapsed = SourceListOutline.visibleItems(from: [group]) { _ in false }
        XCTAssertEqual(collapsed.map(\.title), ["Group"])

        let expanded = SourceListOutline.visibleItems(from: [group]) { id in
            id == group.id
        }
        XCTAssertEqual(expanded.map(\.title), ["Group", "Leaf"])
    }

    func testSelectableItemIdsFiltersGroups() {
        let leaf = SourceItem(title: "Leaf")
        let group = SourceItem.group(title: "Group", children: [leaf])
        let outline = [group, leaf]

        XCTAssertEqual(SourceListOutline.selectableItemIds(in: outline), [leaf.id])
    }
}
