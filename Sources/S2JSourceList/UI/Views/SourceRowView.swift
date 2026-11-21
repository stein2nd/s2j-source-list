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
    let onSelect: () -> Void
    let onEdit: (String) -> Void
    let onCancelEdit: () -> Void
    let customContent: ((SourceItem) -> AnyView)?

    @ScaledMetric(relativeTo: .body) private var scaledIconSize: CGFloat = 16
    @ScaledMetric(relativeTo: .body) private var scaledIndentationStep: CGFloat = 20

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
        self.onSelect = onSelect
        self.onEdit = onEdit
        self.onCancelEdit = onCancelEdit
        self.customContent = customContent
        _editedTitle = State(initialValue: item.title)
        _scaledIconSize = ScaledMetric(wrappedValue: iconSize, relativeTo: .body)
        _scaledIndentationStep = ScaledMetric(wrappedValue: indentationWidth, relativeTo: .body)
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
                    .frame(width: CGFloat(indentationLevel) * scaledIndentationStep)
            }

            // Icon
            if let icon = IconProvider.image(for: item.icon) {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: scaledIconSize, height: scaledIconSize)
                    .foregroundColor(isSelected ? .white : .primary)
            }

            // Content
            if let customContent {
                customContent(item)
            } else {
                defaultContent
            }

            Spacer()

            // Badge
            if let badge = item.badge {
                Text(badge)
                    .font(.caption)
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
        .accessibilityLabel(accessibilityLabelText)
        .accessibilityValue(item.badge ?? "")
        .accessibilityHint(
            NSLocalizedString("SourceList.Accessibility.Row.Hint", bundle: .module, comment: "Row a11y hint")
        )
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityIdentifier("SourceList.Row.\(item.id.uuidString)")
    }

    private var accessibilityLabelText: String {
        if item.hasChildren {
            let groupLabel = NSLocalizedString("SourceList.Accessibility.Group", bundle: .module, comment: "Group row")
            return "\(item.title), \(groupLabel)"
        }
        return item.title
    }

    /**
     * デフォルトのコンテンツを返します。
     * - Returns: デフォルトのコンテンツ
     */
    @ViewBuilder
    private var defaultContent: some View {
        if isEditing, item.isEditable {
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
                .font(.body)
                .foregroundColor(isSelected ? .white : .primary)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
        }
    }
}
