//
//  SourceItem.swift
//  S2JSourceList
//
//  Created by S2J Source List Generator
//

import Foundation
import SwiftUI

/// Represents an item in the source list hierarchy.
///
/// Each item can have a title, icon, badge, children items, and metadata.
/// Items can be editable, selectable, and support custom content rendering.
public struct SourceItem: Identifiable, Equatable, Hashable {
    /// Unique identifier for the item
    public let id: UUID
    
    /// Display title of the item
    public var title: String
    
    /// Optional icon name (system name or asset name)
    public var icon: String?
    
    /// Optional badge text to display
    public var badge: String?
    
    /// Child items for hierarchical structure
    public var children: [SourceItem]?
    
    /// Whether the item can be edited (e.g., renamed)
    public var isEditable: Bool
    
    /// Whether the item can be selected
    public var isSelectable: Bool
    
    /// Custom metadata associated with the item
    public var metadata: [String: Any]?
    
    /// Whether the item is expanded (for groups)
    public var isExpanded: Bool
    
    /// Initializes a new source item.
    ///
    /// - Parameters:
    ///   - id: Unique identifier (defaults to new UUID)
    ///   - title: Display title
    ///   - icon: Optional icon name
    ///   - badge: Optional badge text
    ///   - children: Optional child items
    ///   - isEditable: Whether the item can be edited
    ///   - isSelectable: Whether the item can be selected
    ///   - metadata: Optional custom metadata
    ///   - isExpanded: Whether the item is expanded (for groups)
    public init(
        id: UUID = UUID(),
        title: String,
        icon: String? = nil,
        badge: String? = nil,
        children: [SourceItem]? = nil,
        isEditable: Bool = false,
        isSelectable: Bool = true,
        metadata: [String: Any]? = nil,
        isExpanded: Bool = false
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.badge = badge
        self.children = children
        self.isEditable = isEditable
        self.isSelectable = isSelectable
        self.metadata = metadata
        self.isExpanded = isExpanded
    }
    
    /// Checks if the item has children
    public var hasChildren: Bool {
        guard let children = children else { return false }
        return !children.isEmpty
    }
    
    /// Checks if the item is a group (has children)
    public var isGroup: Bool {
        hasChildren
    }
    
    // MARK: - Equatable
    
    public static func == (lhs: SourceItem, rhs: SourceItem) -> Bool {
        lhs.id == rhs.id
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Convenience Initializers

extension SourceItem {
    /// Creates a group item with children
    public static func group(
        id: UUID = UUID(),
        title: String,
        icon: String? = nil,
        children: [SourceItem],
        isExpanded: Bool = false
    ) -> SourceItem {
        SourceItem(
            id: id,
            title: title,
            icon: icon,
            children: children,
            isSelectable: false,
            isExpanded: isExpanded
        )
    }
    
    /// Creates a simple item without children
    public static func item(
        id: UUID = UUID(),
        title: String,
        icon: String? = nil,
        badge: String? = nil,
        isEditable: Bool = false,
        metadata: [String: Any]? = nil
    ) -> SourceItem {
        SourceItem(
            id: id,
            title: title,
            icon: icon,
            badge: badge,
            isEditable: isEditable,
            metadata: metadata
        )
    }
}
