//
//  SelectionManagerTests.swift
//  S2JSourceListTests
//
//  Created by S2J Source List Generator
//

import XCTest
@testable import S2JSourceList

final class SelectionManagerTests: XCTestCase {
    
    var selectionManager: SelectionManager!
    
    override func setUp() {
        super.setUp()
        selectionManager = SelectionManager()
    }
    
    override func tearDown() {
        selectionManager = nil
        super.tearDown()
    }
    
    func testSingleSelectionMode() {
        selectionManager.selectionMode = .single
        
        let id1 = UUID()
        let id2 = UUID()
        
        selectionManager.selectItem(id1)
        XCTAssertTrue(selectionManager.isSelected(id1))
        XCTAssertEqual(selectionManager.selectedItemIds.count, 1)
        
        selectionManager.selectItem(id2)
        XCTAssertFalse(selectionManager.isSelected(id1))
        XCTAssertTrue(selectionManager.isSelected(id2))
        XCTAssertEqual(selectionManager.selectedItemIds.count, 1)
    }
    
    func testMultipleSelectionMode() {
        selectionManager.selectionMode = .multiple
        
        let id1 = UUID()
        let id2 = UUID()
        let id3 = UUID()
        
        selectionManager.selectItem(id1)
        selectionManager.selectItem(id2)
        selectionManager.selectItem(id3)
        
        XCTAssertTrue(selectionManager.isSelected(id1))
        XCTAssertTrue(selectionManager.isSelected(id2))
        XCTAssertTrue(selectionManager.isSelected(id3))
        XCTAssertEqual(selectionManager.selectedItemIds.count, 3)
    }
    
    func testToggleSelection() {
        let id = UUID()
        
        selectionManager.toggleSelection(id)
        XCTAssertTrue(selectionManager.isSelected(id))
        
        selectionManager.toggleSelection(id)
        XCTAssertFalse(selectionManager.isSelected(id))
    }
    
    func testClearSelection() {
        let id1 = UUID()
        let id2 = UUID()
        
        selectionManager.selectionMode = .multiple
        selectionManager.selectItem(id1)
        selectionManager.selectItem(id2)
        
        selectionManager.clearSelection()
        XCTAssertEqual(selectionManager.selectedItemIds.count, 0)
    }
    
    func testSelectionHistory() {
        let id1 = UUID()
        let id2 = UUID()
        let id3 = UUID()
        
        selectionManager.selectItem(id1)
        selectionManager.selectItem(id2)
        selectionManager.selectItem(id3)
        
        XCTAssertEqual(selectionManager.selectionHistory.count, 3)
        XCTAssertEqual(selectionManager.selectionHistory.first, id3)
    }
    
    func testFirstSelectedId() {
        let id1 = UUID()
        let id2 = UUID()
        
        selectionManager.selectItem(id1)
        XCTAssertEqual(selectionManager.firstSelectedId, id1)
        
        selectionManager.selectItem(id2)
        XCTAssertEqual(selectionManager.firstSelectedId, id2)
    }
}
