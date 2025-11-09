//
//  SourceItemTests.swift
//  S2JSourceListTests
//
//  Created by S2J Source List Generator
//

import XCTest
@testable import S2JSourceList

final class SourceItemTests: XCTestCase {
    
    func testSourceItemInitialization() {
        let item = SourceItem(
            title: "Test Item",
            icon: "folder",
            badge: "5",
            isEditable: true,
            isSelectable: true
        )
        
        XCTAssertEqual(item.title, "Test Item")
        XCTAssertEqual(item.icon, "folder")
        XCTAssertEqual(item.badge, "5")
        XCTAssertTrue(item.isEditable)
        XCTAssertTrue(item.isSelectable)
        XCTAssertFalse(item.hasChildren)
        XCTAssertFalse(item.isGroup)
    }
    
    func testSourceItemWithChildren() {
        let child1 = SourceItem(title: "Child 1")
        let child2 = SourceItem(title: "Child 2")
        let parent = SourceItem(
            title: "Parent",
            children: [child1, child2]
        )
        
        XCTAssertTrue(parent.hasChildren)
        XCTAssertTrue(parent.isGroup)
        XCTAssertEqual(parent.children?.count, 2)
    }
    
    func testSourceItemEquality() {
        let id = UUID()
        let item1 = SourceItem(id: id, title: "Item 1")
        let item2 = SourceItem(id: id, title: "Item 2")
        
        XCTAssertEqual(item1, item2) // Same ID means equal
    }
    
    func testSourceItemConvenienceInitializers() {
        let group = SourceItem.group(
            title: "Group",
            children: [
                SourceItem.item(title: "Item 1"),
                SourceItem.item(title: "Item 2")
            ]
        )
        
        XCTAssertTrue(group.isGroup)
        XCTAssertFalse(group.isSelectable) // Groups are not selectable by default
        XCTAssertEqual(group.children?.count, 2)
        
        let item = SourceItem.item(
            title: "Item",
            icon: "doc",
            badge: "1",
            isEditable: true
        )
        
        XCTAssertFalse(item.hasChildren)
        XCTAssertTrue(item.isSelectable)
        XCTAssertTrue(item.isEditable)
    }
}
