//
//  S2JSourceListPreviews.swift
//  S2JSourceList
//

import SwiftUI

#Preview("Sidebar — search") {
    let service = SourceListPreviewData.makeService()
    let selection = SourceListPreviewData.makeSelection()
    return SidebarView(
        service: service,
        selectionManager: selection,
        showsSearchBar: true
    )
    .frame(width: 280, height: 360)
    .padding()
}

#Preview("Sidebar — drag and drop") {
    let service = SourceListPreviewData.makeService()
    let selection = SourceListPreviewData.makeSelection()
    return SidebarView(
        service: service,
        selectionManager: selection,
        allowsDragAndDrop: true,
        showsSearchBar: true
    )
    .frame(width: 280, height: 360)
    .padding()
}

#Preview("Source row — selected") {
    let item = SourceItem(title: "Documents", icon: "doc.fill", badge: "3")
    return SourceRowView(
        item: item,
        isSelected: true,
        onSelect: {},
        onEdit: { _ in },
        onCancelEdit: {}
    )
    .frame(width: 260)
    .padding()
}

#Preview("Source row — inline edit") {
    let item = SourceItem(title: "Rename me", icon: "pencil", isEditable: true)
    return SourceRowView(
        item: item,
        isSelected: true,
        isEditing: true,
        onSelect: {},
        onEdit: { _ in },
        onCancelEdit: {}
    )
    .frame(width: 260)
    .padding()
}

#Preview("Inline editor") {
    @Previewable @State var title = "Editable title"
    return InlineEditorView(
        text: $title,
        onCommit: {},
        onCancel: { title = "Editable title" }
    )
    .frame(width: 220)
    .padding()
}