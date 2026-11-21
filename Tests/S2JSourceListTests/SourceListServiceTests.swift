//
//  SourceListServiceTests.swift
//  S2JSourceListTests
//
//  Created by S2J Source List Generator
//

import Combine
@testable import S2JSourceList
import XCTest

final class SourceListServiceTests: XCTestCase {
    var service: SourceListService!

    override func setUp() {
        super.setUp()
        service = SourceListService()
    }

    override func tearDown() {
        service = nil
        super.tearDown()
    }

    func testFindItem() {
        let item1 = SourceItem(title: "Item 1")
        let item2 = SourceItem(title: "Item 2")
        let rootItem = SourceItem.group(
            title: "Group",
            children: [item1, item2]
        )

        service.rootItems = [rootItem]

        let found = service.findItem(id: item1.id)
        XCTAssertNotNil(found)
        XCTAssertEqual(found?.item.id, item1.id)
        XCTAssertEqual(found?.parent?.id, rootItem.id)
    }

    func testUpdateItem() {
        let item = SourceItem(title: "Original")
        service.rootItems = [item]

        var updated = item
        updated.title = "Updated"
        service.updateItem(updated)

        let found = service.findItem(id: item.id)
        XCTAssertEqual(found?.item.title, "Updated")
    }

    func testRenameItem() {
        let item = SourceItem(title: "Original", isEditable: true)
        service.rootItems = [item]

        service.renameItem(id: item.id, newTitle: "Renamed")

        let found = service.findItem(id: item.id)
        XCTAssertEqual(found?.item.title, "Renamed")
    }

    func testDeleteItem() {
        let item1 = SourceItem(title: "Item 1")
        let item2 = SourceItem(title: "Item 2")
        service.rootItems = [item1, item2]

        service.deleteItem(id: item1.id)

        XCTAssertEqual(service.rootItems.count, 1)
        XCTAssertEqual(service.rootItems.first?.id, item2.id)
    }

    func testToggleExpansion() {
        let child = SourceItem(title: "Child")
        let group = SourceItem.group(
            title: "Group",
            children: [child],
            isExpanded: false
        )
        service.rootItems = [group]

        service.toggleExpansion(id: group.id)

        let found = service.findItem(id: group.id)
        XCTAssertTrue(found?.item.isExpanded ?? false)
    }

    func testAddItem() {
        let newItem = SourceItem(title: "New Item")
        service.addItem(newItem)

        XCTAssertEqual(service.rootItems.count, 1)
        XCTAssertEqual(service.rootItems.first?.id, newItem.id)
    }

    func testAddItemToParent() {
        let parent = SourceItem.group(title: "Parent", children: [])
        service.rootItems = [parent]

        let child = SourceItem(title: "Child")
        service.addItem(child, parentId: parent.id)

        let found = service.findItem(id: parent.id)
        XCTAssertEqual(found?.item.children?.count, 1)
        XCTAssertEqual(found?.item.children?.first?.id, child.id)
    }

    func testMoveItemAfterSiblingAtRoot() {
        let item1 = SourceItem(title: "Item 1")
        let item2 = SourceItem(title: "Item 2")
        service.rootItems = [item1, item2]

        XCTAssertTrue(service.moveItem(id: item1.id, to: .afterSibling(siblingId: item2.id)))

        XCTAssertEqual(service.rootItems.map(\.id), [item2.id, item1.id])
    }

    func testMoveItemAppendToParent() {
        let group = SourceItem.group(title: "Group", children: [])
        let leaf = SourceItem(title: "Leaf")
        service.rootItems = [group, leaf]

        XCTAssertTrue(service.moveItem(id: leaf.id, to: .appendToParent(parentId: group.id)))

        let found = service.findItem(id: group.id)
        XCTAssertEqual(found?.item.children?.map(\.id), [leaf.id])
        XCTAssertEqual(service.rootItems.map(\.id), [group.id])
    }

    func testMoveItemRejectsDescendantDrop() {
        let grandchild = SourceItem(title: "Grandchild")
        let child = SourceItem.group(title: "Child", children: [grandchild])
        let root = SourceItem.group(title: "Root", children: [child])
        service.rootItems = [root]

        XCTAssertFalse(service.moveItem(id: root.id, to: .appendToParent(parentId: child.id)))
        XCTAssertEqual(service.rootItems.first?.id, root.id)
    }

    func testMoveItemPublishesItemsMoved() {
        let item1 = SourceItem(title: "A")
        let item2 = SourceItem(title: "B")
        service.rootItems = [item1, item2]

        let expectation = expectation(description: "itemsMoved")
        var received: SourceListService.SourceListItemMoveEvent?
        let cancellable = service.itemsMoved.sink { event in
            received = event
            expectation.fulfill()
        }
        defer { cancellable.cancel() }

        XCTAssertTrue(service.moveItem(id: item1.id, to: .afterSibling(siblingId: item2.id)))
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(received?.itemId, item1.id)
        XCTAssertNil(received?.newParentId)
        XCTAssertEqual(received?.newIndex, 1)
    }

    func testIsDescendant() {
        let leaf = SourceItem(title: "Leaf")
        let child = SourceItem.group(title: "Child", children: [leaf])
        let root = SourceItem.group(title: "Root", children: [child])
        service.rootItems = [root]

        XCTAssertTrue(service.isDescendant(itemId: leaf.id, of: root.id))
        XCTAssertFalse(service.isDescendant(itemId: root.id, of: leaf.id))
    }
}
