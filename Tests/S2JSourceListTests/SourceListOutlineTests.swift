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

    func testFilterItemsMatchesTitleAndDescendants() {
        let child = SourceItem(title: "Target Leaf")
        let group = SourceItem.group(title: "Folder", children: [child])
        let other = SourceItem(title: "Other")

        let byChild = SourceListOutline.filterItems([group, other], searchText: "target")
        XCTAssertEqual(byChild.count, 1)
        XCTAssertEqual(byChild.first?.children?.first?.title, "Target Leaf")

        let byGroup = SourceListOutline.filterItems([group, other], searchText: "folder")
        XCTAssertEqual(byGroup.map(\.title), ["Folder"])

        XCTAssertTrue(SourceListOutline.filterItems([other], searchText: "missing").isEmpty)
    }
}
