//
//  SourceListOutline.swift
//  S2JSourceList
//

import Foundation

enum SourceListOutline {
    static func visibleItems(
        from roots: [SourceItem],
        isExpanded: (UUID) -> Bool
    ) -> [SourceItem] {
        var result: [SourceItem] = []
        func walk(_ items: [SourceItem]) {
            for item in items {
                result.append(item)
                if item.hasChildren, isExpanded(item.id), let children = item.children {
                    walk(children)
                }
            }
        }
        walk(roots)
        return result
    }

    static func selectableItemIds(in outline: [SourceItem]) -> [UUID] {
        outline.filter(\.isSelectable).map(\.id)
    }

    static func filterItems(_ items: [SourceItem], searchText: String) -> [SourceItem] {
        let lowercased = searchText.lowercased()
        return items.compactMap { item in
            var filtered = item
            if let children = item.children {
                let filteredChildren = filterItems(children, searchText: searchText)
                if !filteredChildren.isEmpty || item.title.lowercased().contains(lowercased) {
                    filtered.children = filteredChildren
                    filtered.isExpanded = true
                    return filtered
                }
            } else if item.title.lowercased().contains(lowercased) {
                return filtered
            }
            return nil
        }
    }
}
