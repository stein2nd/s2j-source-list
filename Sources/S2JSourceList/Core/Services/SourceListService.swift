//
//  SourceListService.swift
//  S2JSourceList
//
//  Created by S2J Source List Generator
//

import Foundation
import Combine
import SwiftUI

/// Service for managing source list data and persistence.
///
/// Provides data to the source list view and handles persistence operations.
public final class SourceListService: ObservableObject {
    /// Root items of the source list
    @Published public var rootItems: [SourceItem]
    
    /// Publisher for item changes
    public let itemsChanged = PassthroughSubject<[SourceItem], Never>()
    
    /// Publisher for item rename events
    public let itemRenamed = PassthroughSubject<(UUID, String), Never>()
    
    /// Publisher for item deletion events
    public let itemDeleted = PassthroughSubject<UUID, Never>()
    
    /// Initializes a new source list service.
    ///
    /// - Parameter rootItems: Initial root items (defaults to empty array)
    public init(rootItems: [SourceItem] = []) {
        self.rootItems = rootItems
    }
    
    /// Finds an item by ID in the hierarchy.
    ///
    /// - Parameter id: ID of the item to find
    /// - Returns: Found item and its parent, or nil if not found
    public func findItem(id: UUID) -> (item: SourceItem, parent: SourceItem?)? {
        for rootItem in rootItems {
            if rootItem.id == id {
                return (rootItem, nil)
            }
            if let result = findItemInChildren(id: id, parent: rootItem, children: rootItem.children) {
                return result
            }
        }
        return nil
    }
    
    private func findItemInChildren(id: UUID, parent: SourceItem, children: [SourceItem]?) -> (item: SourceItem, parent: SourceItem)? {
        guard let children = children else { return nil }
        for child in children {
            if child.id == id {
                return (child, parent)
            }
            if let result = findItemInChildren(id: id, parent: child, children: child.children) {
                return result
            }
        }
        return nil
    }
    
    /// Updates an item in the hierarchy.
    ///
    /// - Parameter item: Updated item
    public func updateItem(_ item: SourceItem) {
        if let index = rootItems.firstIndex(where: { $0.id == item.id }) {
            rootItems[index] = item
            itemsChanged.send(rootItems)
            return
        }
        _ = updateItemInChildren(item, children: &rootItems)
        itemsChanged.send(rootItems)
    }
    
    private func updateItemInChildren(_ item: SourceItem, children: inout [SourceItem]) -> Bool {
        for index in children.indices {
            if children[index].id == item.id {
                children[index] = item
                return true
            }
            if var childChildren = children[index].children {
                if updateItemInChildren(item, children: &childChildren) {
                    children[index].children = childChildren
                    return true
                }
            }
        }
        return false
    }
    
    /// Renames an item.
    ///
    /// - Parameters:
    ///   - id: ID of the item to rename
    ///   - newTitle: New title for the item
    public func renameItem(id: UUID, newTitle: String) {
        guard var item = findItem(id: id)?.item else { return }
        item.title = newTitle
        updateItem(item)
        itemRenamed.send((id, newTitle))
    }
    
    /// Deletes an item from the hierarchy.
    ///
    /// - Parameter id: ID of the item to delete
    public func deleteItem(id: UUID) {
        if let index = rootItems.firstIndex(where: { $0.id == id }) {
            rootItems.remove(at: index)
            itemsChanged.send(rootItems)
            itemDeleted.send(id)
            return
        }
        _ = deleteItemFromChildren(id: id, children: &rootItems)
        itemsChanged.send(rootItems)
        itemDeleted.send(id)
    }
    
    private func deleteItemFromChildren(id: UUID, children: inout [SourceItem]) -> Bool {
        for index in children.indices {
            if children[index].id == id {
                children.remove(at: index)
                return true
            }
            if var childChildren = children[index].children {
                if deleteItemFromChildren(id: id, children: &childChildren) {
                    children[index].children = childChildren.isEmpty ? nil : childChildren
                    return true
                }
            }
        }
        return false
    }
    
    /// Toggles expansion state of a group item.
    ///
    /// - Parameter id: ID of the group item
    public func toggleExpansion(id: UUID) {
        guard var item = findItem(id: id)?.item, item.hasChildren else { return }
        item.isExpanded.toggle()
        updateItem(item)
    }
    
    /// Expands a group item.
    ///
    /// - Parameter id: ID of the group item
    public func expandItem(id: UUID) {
        guard var item = findItem(id: id)?.item, item.hasChildren, !item.isExpanded else { return }
        item.isExpanded = true
        updateItem(item)
    }
    
    /// Collapses a group item.
    ///
    /// - Parameter id: ID of the group item
    public func collapseItem(id: UUID) {
        guard var item = findItem(id: id)?.item, item.hasChildren, item.isExpanded else { return }
        item.isExpanded = false
        updateItem(item)
    }
    
    /// Adds a new item as a child of the specified parent.
    ///
    /// - Parameters:
    ///   - item: Item to add
    ///   - parentId: ID of the parent item (nil for root level)
    public func addItem(_ item: SourceItem, parentId: UUID? = nil) {
        if let parentId = parentId {
            _ = addItemToParent(item, parentId: parentId, children: &rootItems)
        } else {
            rootItems.append(item)
        }
        itemsChanged.send(rootItems)
    }
    
    private func addItemToParent(_ item: SourceItem, parentId: UUID, children: inout [SourceItem]) -> Bool {
        for index in children.indices {
            if children[index].id == parentId {
                if children[index].children == nil {
                    children[index].children = []
                }
                children[index].children?.append(item)
                return true
            }
            if var childChildren = children[index].children {
                if addItemToParent(item, parentId: parentId, children: &childChildren) {
                    children[index].children = childChildren
                    return true
                }
            }
        }
        return false
    }
}
