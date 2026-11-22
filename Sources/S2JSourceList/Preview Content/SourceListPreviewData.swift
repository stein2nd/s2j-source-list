//
//  SourceListPreviewData.swift
//  S2JSourceList
//
//  Xcode Preview および DocC サンプル用の共有データ。
//

import Foundation

@MainActor
enum SourceListPreviewData {
    static let sampleRootItems: [SourceItem] = [
        .group(
            title: "Favorites",
            icon: "star.fill",
            children: [
                .item(title: "Documents", icon: "doc.fill", badge: "3"),
                .item(title: "Downloads", icon: "arrow.down.circle")
            ],
            isExpanded: true
        ),
        .item(title: "Inbox", icon: "tray", badge: "2"),
        .group(
            title: "Editable",
            icon: "pencil",
            children: [
                SourceItem(title: "Rename me", icon: "text.cursor", isEditable: true)
            ],
            isExpanded: true
        )
    ]

    @MainActor
    static func makeService(rootItems: [SourceItem]? = nil) -> SourceListService {
        SourceListService(rootItems: rootItems ?? sampleRootItems)
    }

    @MainActor
    static func makeSelection(multiple: Bool = false) -> SelectionManager {
        SelectionManager(selectionMode: multiple ? .multiple : .single)
    }
}
