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
}
