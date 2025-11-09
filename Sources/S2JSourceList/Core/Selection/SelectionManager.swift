//
//  SelectionManager.swift
//  S2JSourceList
//
//  Created by S2J Source List Generator
//

import Foundation
import Combine
import SwiftUI

/// Manages selection state for source list items.
///
/// Supports both single and multiple selection modes, selection history,
/// and programmatic selection.
public final class SelectionManager: ObservableObject {
    /// Selection mode
    public enum SelectionMode {
        case single
        case multiple
    }
    
    /// Current selection mode
    @Published public var selectionMode: SelectionMode
    
    /// Currently selected item IDs
    @Published public private(set) var selectedItemIds: Set<UUID>
    
    /// Selection history (for navigation)
    @Published public private(set) var selectionHistory: [UUID]
    
    /// Maximum history size
    public var maxHistorySize: Int = 50
    
    /// Publisher for selection changes
    public let selectionChanged = PassthroughSubject<Set<UUID>, Never>()
    
    /// Initializes a new selection manager.
    ///
    /// - Parameter selectionMode: Selection mode (defaults to single)
    public init(selectionMode: SelectionMode = .single) {
        self.selectionMode = selectionMode
        self.selectedItemIds = []
        self.selectionHistory = []
    }
    
    /// Selects an item.
    ///
    /// - Parameter itemId: ID of the item to select
    public func selectItem(_ itemId: UUID) {
        switch selectionMode {
        case .single:
            selectedItemIds = [itemId]
        case .multiple:
            selectedItemIds.insert(itemId)
        }
        addToHistory(itemId)
        selectionChanged.send(selectedItemIds)
    }
    
    /// Deselects an item.
    ///
    /// - Parameter itemId: ID of the item to deselect
    public func deselectItem(_ itemId: UUID) {
        selectedItemIds.remove(itemId)
        selectionChanged.send(selectedItemIds)
    }
    
    /// Toggles selection of an item.
    ///
    /// - Parameter itemId: ID of the item to toggle
    public func toggleSelection(_ itemId: UUID) {
        if selectedItemIds.contains(itemId) {
            deselectItem(itemId)
        } else {
            selectItem(itemId)
        }
    }
    
    /// Clears all selections.
    public func clearSelection() {
        selectedItemIds.removeAll()
        selectionChanged.send(selectedItemIds)
    }
    
    /// Selects multiple items (for multiple selection mode).
    ///
    /// - Parameter itemIds: IDs of items to select
    public func selectItems(_ itemIds: Set<UUID>) {
        guard selectionMode == .multiple else {
            // In single mode, select only the first item
            if let firstId = itemIds.first {
                selectItem(firstId)
            }
            return
        }
        selectedItemIds.formUnion(itemIds)
        if let lastId = itemIds.first {
            addToHistory(lastId)
        }
        selectionChanged.send(selectedItemIds)
    }
    
    /// Checks if an item is selected.
    ///
    /// - Parameter itemId: ID of the item to check
    /// - Returns: True if the item is selected
    public func isSelected(_ itemId: UUID) -> Bool {
        selectedItemIds.contains(itemId)
    }
    
    /// Gets the first selected item ID.
    ///
    /// - Returns: First selected item ID, or nil if none selected
    public var firstSelectedId: UUID? {
        selectedItemIds.first
    }
    
    // MARK: - History Management
    
    private func addToHistory(_ itemId: UUID) {
        // Remove if already exists
        selectionHistory.removeAll { $0 == itemId }
        // Add to front
        selectionHistory.insert(itemId, at: 0)
        // Trim to max size
        if selectionHistory.count > maxHistorySize {
            selectionHistory = Array(selectionHistory.prefix(maxHistorySize))
        }
    }
    
    /// Navigates to previous selection in history.
    ///
    /// - Returns: Previous item ID, or nil if no history
    public func navigateToPrevious() -> UUID? {
        guard selectionHistory.count > 1 else { return nil }
        let previous = selectionHistory[1]
        selectItem(previous)
        return previous
    }
    
    /// Navigates to next selection in history.
    ///
    /// - Returns: Next item ID, or nil if no next item
    public func navigateToNext() -> UUID? {
        guard !selectionHistory.isEmpty, selectionHistory.count > 1 else { return nil }
        // This is a simplified implementation
        // In a full implementation, you'd track forward history
        return nil
    }
}
