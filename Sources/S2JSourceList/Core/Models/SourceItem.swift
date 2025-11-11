//
//  SourceItem.swift
//  S2JSourceList
//
//  Created by S2J Source List Generator
//

import Foundation
import SwiftUI

/** 
 * ソースリスト階層内の項目を表す構造体
 * アイテムにはタイトル、アイコン、バッジ、子アイテム、メタデータがあります。
 * アイテムは編集可能、選択可能であり、カスタム・コンテンツのレンダリングをサポートします。
 */
public struct SourceItem: Identifiable, Equatable, Hashable {

    /** 
     * アイテムの ID
     */
    public let id: UUID

    /** 
     * アイテムのタイトル
     */
    public var title: String

    /** 
     * アイコンの名前
     */
    public var icon: String?

    /** 
     * バッジのテキスト
     */
    public var badge: String?

    /** 
     * 子アイテムの配列
     */
    public var children: [SourceItem]?

    /** 
     * アイテムが編集可能かどうか
     */
    public var isEditable: Bool

    /** 
     * アイテムが選択可能かどうか
     */
    public var isSelectable: Bool

    /** 
     * アイテムのメタデータ
     */
    public var metadata: [String: Any]?

    /** 
     * アイテムが展開されているかどうか
     */
    public var isExpanded: Bool

    /** 
     * 新しいソースアイテムを作成します。
     * - Parameter id: アイテムの ID
     * - Parameter title: アイテムのタイトル
     * - Parameter icon: アイコンの名前
     * - Parameter badge: バッジのテキスト
     * - Parameter children: 子アイテムの配列
     * - Parameter isEditable: アイテムが編集可能かどうか
     * - Parameter isSelectable: アイテムが選択可能かどうか
     * - Parameter metadata: アイテムのメタデータ
     */
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

    /** 
     * アイテムが子要素を持つかどうかを判定します。
     * - Returns: 子要素を持つかどうか
     */
    public var hasChildren: Bool {
        guard let children = children else { return false }
        return !children.isEmpty
    }

    /** 
     * アイテムが子要素を持つかどうかを判定します。
     * - Returns: 子要素を持つかどうか
     */
    public var isGroup: Bool {
        hasChildren
    }

    // MARK: - Equatable

    /** 
     * アイテムが等しいかどうかを判定します。
     * - Parameter lhs: 左辺のアイテム
     * - Parameter rhs: 右辺のアイテム
     * - Returns: 等しいかどうか
     */
    public static func == (lhs: SourceItem, rhs: SourceItem) -> Bool {
        lhs.id == rhs.id
    }
    
    // MARK: - Hashable

    /** 
     * アイテムのハッシュ値を計算します。
     * - Parameter hasher: ハッシュ値を計算するためのハッシュ
     */
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Convenience Initializers

extension SourceItem {
    /** 
     * 子アイテムを持つグループアイテムを作成します。
     * - Parameter id: アイテムの ID
     * - Parameter title: アイテムのタイトル
     * - Parameter icon: アイコンの名前
     * - Parameter children: 子アイテムの配列
     * - Parameter isExpanded: アイテムが展開されているかどうか
     */
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

    /** 
     * 子アイテムなしのシンプルなアイテムを作成します。
     * - Parameter id: アイテムの ID
     * - Parameter title: アイテムのタイトル
     * - Parameter icon: アイコンの名前
     * - Parameter badge: バッジのテキスト
     * - Parameter isEditable: アイテムが編集可能かどうか
     * - Parameter metadata: アイテムのメタデータ
     */
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
