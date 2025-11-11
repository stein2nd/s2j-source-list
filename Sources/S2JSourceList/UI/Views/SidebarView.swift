//
//  SidebarView.swift
//  S2JSourceList
//
//  Created by S2J Source List Generator
//

import SwiftUI

/** 
 * 階層的なソースリストを表示するための、サイドバーのメイン・コンポーネント
 */
public struct SidebarView: View {

    @ObservedObject var service: SourceListService
    @ObservedObject var selectionManager: SelectionManager

    // Configuration
    let allowsMultipleSelection: Bool
    let allowsDragAndDrop: Bool
    let showsSearchBar: Bool
    let indentationWidth: CGFloat
    let iconSize: CGFloat
    let customRowContent: ((SourceItem) -> AnyView)?
    let contextMenuBuilder: ((SourceItem) -> [ContextMenuAction])?

    // State
    @State private var searchText: String = ""
    @State private var editingItemId: UUID?
    @State private var expandedItemIds: Set<UUID> = []

    /** 
     * コンテキストメニュー・アクション
     */
    public struct ContextMenuAction: Identifiable {
        public let id = UUID()
        public let title: String
        public let action: () -> Void
        public let isDestructive: Bool
        
        public init(title: String, action: @escaping () -> Void, isDestructive: Bool = false) {
            self.title = title
            self.action = action
            self.isDestructive = isDestructive
        }
    }

    /** 
     * サイドバーのイニシャライザー
     * - Parameter service: サイドバーのサービス
     * - Parameter selectionManager: サイドバーの選択マネージャー
     * - Parameter allowsMultipleSelection: 複数選択を許可するかどうか
     * - Parameter allowsDragAndDrop: ドラッグアンドドロップを許可するかどうか
     * - Parameter showsSearchBar: 検索バーを表示するかどうか
     * - Parameter indentationWidth: インデントの幅
     * - Parameter iconSize: アイコンのサイズ
     * - Parameter customRowContent: カスタム行コンテンツ
     */
    public init(
        service: SourceListService,
        selectionManager: SelectionManager,
        allowsMultipleSelection: Bool = false,
        allowsDragAndDrop: Bool = false,
        showsSearchBar: Bool = false,
        indentationWidth: CGFloat = 20,
        iconSize: CGFloat = 16,
        customRowContent: ((SourceItem) -> AnyView)? = nil,
        contextMenuBuilder: ((SourceItem) -> [ContextMenuAction])? = nil
    ) {
        self.service = service
        self.selectionManager = selectionManager
        self.allowsMultipleSelection = allowsMultipleSelection
        self.allowsDragAndDrop = allowsDragAndDrop
        self.showsSearchBar = showsSearchBar
        self.indentationWidth = indentationWidth
        self.iconSize = iconSize
        self.customRowContent = customRowContent
        self.contextMenuBuilder = contextMenuBuilder
        
        // Sync selection mode
        selectionManager.selectionMode = allowsMultipleSelection ? .multiple : .single
    }

    /** 
     * サイドバーのボディを返します。
     * - Returns: サイドバーのボディ
     */
    public var body: some View {
        VStack(spacing: 0) {
            // Search bar
            if showsSearchBar {
                searchBarView
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
            }
            
            // List
            listView
        }
        .onAppear {
            // Initialize expanded items
            updateExpandedItems()
        }
        .onChange(of: service.rootItems) { _ in
            updateExpandedItems()
        }
    }

    @ViewBuilder
    /** 
     * 検索バーを返します。
     * - Returns: 検索バー
     */
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField(
                NSLocalizedString("SourceList.Search.Placeholder", bundle: .module, comment: "Search placeholder"),
                text: $searchText
            )
            .textFieldStyle(.plain)
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(0.1))
        )
    }

    @ViewBuilder
    /** 
     * リストビューを返します。
     * - Returns: リストビュー
     */
    private var listView: some View {
        List {
            ForEach(filteredItems) { item in
                itemRow(item, level: 0)
            }
        }
        #if os(macOS)
        .listStyle(.sidebar)
        #else
        .listStyle(.insetGrouped)
        #endif
    }

    /** 
     * アイテムの行コンテンツを返します。
     * - Parameter item: アイテム
     * - Parameter level: レベル
     * - Returns: 行コンテンツ
     */
    private func itemRow(_ item: SourceItem, level: Int) -> AnyView {
        let isSelected = selectionManager.isSelected(item.id)
        let isEditing = editingItemId == item.id
        let itemIsExpanded = isItemExpanded(item)
        
        if item.hasChildren {
            return AnyView(
                DisclosureGroup(isExpanded: Binding(
                    get: { itemIsExpanded },
                    set: { _ in toggleExpansion(item.id) }
                )) {
                    ForEach(item.children ?? []) { child in
                        itemRow(child, level: level + 1)
                    }
                } label: {
                    rowContent(for: item, isSelected: isSelected, isEditing: isEditing, level: level)
                }
            )
        } else {
            return AnyView(
                rowContent(for: item, isSelected: isSelected, isEditing: isEditing, level: level)
            )
        }
    }

    @ViewBuilder
    /** 
     * アイテムの行コンテンツを返します。
     * - Parameter item: アイテム
     * - Parameter isSelected: 選択されているかどうか
     * - Parameter isEditing: 編集中かどうか
     * - Parameter level: レベル
     * - Returns: 行コンテンツ
     */
    private func rowContent(for item: SourceItem, isSelected: Bool, isEditing: Bool, level: Int) -> some View {
        SourceRowView(
            item: item,
            isSelected: isSelected,
            isEditing: isEditing,
            indentationLevel: level,
            indentationWidth: indentationWidth,
            iconSize: iconSize,
            onSelect: {
                if item.isSelectable {
                    selectionManager.selectItem(item.id)
                }
            },
            onEdit: { newTitle in
                service.renameItem(id: item.id, newTitle: newTitle)
                editingItemId = nil
            },
            onCancelEdit: {
                editingItemId = nil
            },
            customContent: customRowContent
        )
        .contextMenu {
            if let actions = contextMenuBuilder?(item) {
                ForEach(actions) { action in
                    Button(role: action.isDestructive ? .destructive : nil, action: action.action) {
                        Text(action.title)
                    }
                }
            } else {
                defaultContextMenu(for: item)
            }
        }
        .onTapGesture {
            if item.isSelectable {
                if allowsMultipleSelection {
                    selectionManager.toggleSelection(item.id)
                } else {
                    selectionManager.selectItem(item.id)
                }
            }
        }
    }

    @ViewBuilder
    /** 
     * デフォルトのコンテキストメニューを返します。
     * - Parameter item: アイテム
     * - Returns: コンテキストメニュー
     */
    private func defaultContextMenu(for item: SourceItem) -> some View {
        if item.isEditable {
            Button(action: {
                editingItemId = item.id
            }) {
                Text(NSLocalizedString("SourceList.Edit.Rename", bundle: .module, comment: "Rename"))
            }
        }
        
        if item.hasChildren {
            Button(action: {
                toggleExpansion(item.id)
            }) {
                Text(isItemExpanded(item) ?
                     NSLocalizedString("SourceList.Collapse", bundle: .module, comment: "Collapse") :
                     NSLocalizedString("SourceList.Expand", bundle: .module, comment: "Expand"))
            }
        }
    }

    // MARK: - Helper Methods

    /** 
     * フィルタリングされたアイテムの配列を返します。
     * - Returns: フィルタリングされたアイテムの配列
     */
    private var filteredItems: [SourceItem] {
        if searchText.isEmpty {
            return service.rootItems
        }
        return filterItems(service.rootItems, searchText: searchText)
    }

    /** 
     * アイテムをフィルタリングします。
     * - Parameter items: アイテムの配列
     * - Parameter searchText: 検索テキスト
     * - Returns: フィルタリングされたアイテムの配列
     */
    private func filterItems(_ items: [SourceItem], searchText: String) -> [SourceItem] {
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

    /** 
     * アイテムが展開されているかどうかを返します。
     * - Parameter item: アイテム
     * - Returns: 展開されているかどうか
     */
    private func isItemExpanded(_ item: SourceItem) -> Bool {
        expandedItemIds.contains(item.id) || item.isExpanded
    }

    /** 
     * アイテムの展開状態を切り替えます。
     * - Parameter itemId: アイテムの ID
     */
    private func toggleExpansion(_ itemId: UUID) {
        if expandedItemIds.contains(itemId) {
            expandedItemIds.remove(itemId)
            service.collapseItem(id: itemId)
        } else {
            expandedItemIds.insert(itemId)
            service.expandItem(id: itemId)
        }
    }

    /** 
     * 展開されたアイテムを更新します。
     */
    private func updateExpandedItems() {
        var expanded: Set<UUID> = []
        func collectExpanded(_ items: [SourceItem]) {
            for item in items {
                if item.isExpanded {
                    expanded.insert(item.id)
                }
                if let children = item.children {
                    collectExpanded(children)
                }
            }
        }
        collectExpanded(service.rootItems)
        expandedItemIds = expanded
    }
}
