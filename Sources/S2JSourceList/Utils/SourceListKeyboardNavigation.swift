//
//  SourceListKeyboardNavigation.swift
//  S2JSourceList
//

import Foundation

enum SourceListKeyboardNavigation {
    static func nextSelectableId(
        selectableIds: [UUID],
        currentId: UUID?,
        offset: Int
    ) -> UUID? {
        guard !selectableIds.isEmpty else { return nil }
        let currentIndex = currentId.flatMap { selectableIds.firstIndex(of: $0) } ?? 0
        let nextIndex = min(max(currentIndex + offset, 0), selectableIds.count - 1)
        if nextIndex == currentIndex, currentId != nil { return nil }
        return selectableIds[nextIndex]
    }

    static func contextItem(in outline: [SourceItem], selectedId: UUID?) -> SourceItem? {
        guard !outline.isEmpty else { return nil }
        if let selectedId,
           let item = outline.first(where: { $0.id == selectedId })
        {
            return item
        }
        return outline.first
    }

    static func shouldToggleExpansion(
        item: SourceItem,
        isExpanded: Bool,
        expand: Bool
    ) -> Bool {
        guard item.hasChildren else { return false }
        if expand { return !isExpanded }
        return isExpanded
    }
}