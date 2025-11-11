//
//  SourceRowView.swift
//  S2JSourceList
//
//  Created by S2J Source List Generator
//

import SwiftUI

/** 
 * ソースリストのアイテムの行コンテンツを表示するためのビュー
 */
public struct SourceRowView: View {

    let item: SourceItem
    let isSelected: Bool
    let isEditing: Bool
    let indentationLevel: Int
    let indentationWidth: CGFloat
    let iconSize: CGFloat
    let onSelect: () -> Void
    let onEdit: (String) -> Void
    let onCancelEdit: () -> Void
    let customContent: ((SourceItem) -> AnyView)?

    @State private var editedTitle: String

    /** 
     * ソースリストのアイテムの行コンテンナのイニシャライザー
     * - Parameter item: ソースリストのアイテム
     * - Parameter isSelected: 選択されているかどうか
     * - Parameter isEditing: 編集中かどうか
     * - Parameter indentationLevel: インデントのレベル
     * - Parameter indentationWidth: インデントの幅
     * - Parameter iconSize: アイコンのサイズ
     * - Parameter onSelect: 選択時のアクション
     * - Parameter onEdit: 編集時のアクション
     * - Parameter onCancelEdit: キャンセル時のアクション
     * - Parameter customContent: カスタムコンテンツ
     */
    public init(
        item: SourceItem,
        isSelected: Bool,
        isEditing: Bool = false,
        indentationLevel: Int = 0,
        indentationWidth: CGFloat = 20,
        iconSize: CGFloat = 16,
        onSelect: @escaping () -> Void,
        onEdit: @escaping (String) -> Void,
        onCancelEdit: @escaping () -> Void,
        customContent: ((SourceItem) -> AnyView)? = nil
    ) {
        self.item = item
        self.isSelected = isSelected
        self.isEditing = isEditing
        self.indentationLevel = indentationLevel
        self.indentationWidth = indentationWidth
        self.iconSize = iconSize
        self.onSelect = onSelect
        self.onEdit = onEdit
        self.onCancelEdit = onCancelEdit
        self.customContent = customContent
        self._editedTitle = State(initialValue: item.title)
    }

    /** 
     * ソースリストのアイテムの行コンテンツを返します。
     * - Returns: ソースリストのアイテムの行コンテンツ
     */
    public var body: some View {
        HStack(spacing: 6) {
            // Indentation
            if indentationLevel > 0 {
                Spacer()
                    .frame(width: CGFloat(indentationLevel) * indentationWidth)
            }
            
            // Icon
            if let icon = IconProvider.image(for: item.icon) {
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize, height: iconSize)
                    .foregroundColor(isSelected ? .white : .primary)
            }
            
            // Content
            if let customContent = customContent {
                customContent(item)
            } else {
                defaultContent
            }
            
            Spacer()
            
            // Badge
            if let badge = item.badge {
                Text(badge)
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(isSelected ? Color.white.opacity(0.3) : Color.secondary.opacity(0.2))
                    )
                    .foregroundColor(isSelected ? .white : .primary)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(isSelected ? Color.accentColor : Color.clear)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            if !isEditing {
                onSelect()
            }
        }
        .accessibilityLabel(item.title)
        .accessibilityValue(item.badge ?? "")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    @ViewBuilder
    /** 
     * デフォルトのコンテンツを返します。
     * - Returns: デフォルトのコンテンツ
     */
    private var defaultContent: some View {
        if isEditing && item.isEditable {
            InlineEditorView(
                text: $editedTitle,
                onCommit: {
                    onEdit(editedTitle)
                },
                onCancel: {
                    editedTitle = item.title
                    onCancelEdit()
                }
            )
        } else {
            Text(item.title)
                .foregroundColor(isSelected ? .white : .primary)
                .lineLimit(1)
        }
    }
}
