//
//  SourceListUserFlowTests.swift
//  S2JSourceListTests
//
//  主要操作の統合検証 (macOS / iPadOS 共通。XCUITest の代わりに Service + Selection でフローを再現)
//

import Combine
@testable import S2JSourceList
import XCTest

final class SourceListUserFlowTests: XCTestCase {
    func testSelectExpandRenameAndMove() {
        let child = SourceItem(title: "Child", isEditable: true)
        let group = SourceItem.group(title: "Group", children: [child], isExpanded: false)
        let leaf = SourceItem(title: "Leaf")
        let service = SourceListService(rootItems: [group, leaf])
        let selection = SelectionManager()

        selection.selectItem(child.id)
        XCTAssertTrue(selection.isSelected(child.id))

        service.expandItem(id: group.id)
        XCTAssertTrue(service.findItem(id: group.id)?.item.isExpanded ?? false)

        service.renameItem(id: child.id, newTitle: "Renamed")
        XCTAssertEqual(service.findItem(id: child.id)?.item.title, "Renamed")

        XCTAssertTrue(service.moveItem(id: leaf.id, to: .appendToParent(parentId: group.id)))
        XCTAssertEqual(service.findItem(id: group.id)?.item.children?.count, 2)
    }
}
