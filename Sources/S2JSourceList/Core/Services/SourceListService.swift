//
//  SourceListService.swift
//  S2JSourceList
//
//  Created by S2J Source List Generator
//

import Combine
import Foundation
import SwiftUI

/**
 * ソースリストデータの管理と永続化のためのサービス
 */
public final class SourceListService: ObservableObject {
    /**
     * ルートアイテムの配列
     */
    @Published public var rootItems: [SourceItem]

    /**
     * アイテム変更イベントのパブリッシャー
     */
    public let itemsChanged = PassthroughSubject<[SourceItem], Never>()

    /**
     * アイテムリネームイベントのパブリッシャー
     */
    public let itemRenamed = PassthroughSubject<(UUID, String), Never>()

    /**
     * アイテム削除イベントのパブリッシャー
     */
    public let itemDeleted = PassthroughSubject<UUID, Never>()

    /**
     * アイテム移動イベントのパブリッシャー (ドラッグ & ドロップ完了時)
     */
    public let itemsMoved = PassthroughSubject<SourceListItemMoveEvent, Never>()

    /**
     * 新しいソースリストサービスを初期化します。
     * - Parameter rootItems: 初期のルートアイテム (デフォルトは空の配列)
     */
    public init(rootItems: [SourceItem] = []) {
        self.rootItems = rootItems
    }

    /**
     * アイテムを検索します。
     * - Parameter id: アイテムの ID
     * - Returns: 見つかったアイテムとその親
     */
    public func findItem(id: UUID) -> (item: SourceItem, parent: SourceItem?)? {
        for rootItem in rootItems {
            if rootItem.id == id {
                return (rootItem, nil)
            }
            if let result = findItemInChildren(id: id, parent: rootItem, children: rootItem.children) {
                return result
            }
        }
        return nil
    }

    /**
     * 子アイテムを検索します。
     * - Parameter id: アイテムの ID
     * - Parameter parent: 親アイテム
     * - Parameter children: 子アイテムの配列
     * - Returns: 見つかったアイテムとその親
     */
    private func findItemInChildren(
        id: UUID,
        parent: SourceItem,
        children: [SourceItem]?
    ) -> (item: SourceItem, parent: SourceItem)? {
        guard let children else { return nil }
        for child in children {
            if child.id == id {
                return (child, parent)
            }
            if let result = findItemInChildren(id: id, parent: child, children: child.children) {
                return result
            }
        }
        return nil
    }

    /**
     * アイテムを更新します。
     * - Parameter item: 更新するアイテム
     */
    public func updateItem(_ item: SourceItem) {
        if let index = rootItems.firstIndex(where: { $0.id == item.id }) {
            rootItems[index] = item
            itemsChanged.send(rootItems)
            return
        }
        _ = updateItemInChildren(item, children: &rootItems)
        itemsChanged.send(rootItems)
    }

    /**
     * 子アイテムを更新します。
     * - Parameter item: 更新するアイテム
     * - Parameter children: 子アイテムの配列
     * - Returns: 更新が成功したかどうか
     */
    private func updateItemInChildren(_ item: SourceItem, children: inout [SourceItem]) -> Bool {
        for index in children.indices {
            if children[index].id == item.id {
                children[index] = item
                return true
            }
            if var childChildren = children[index].children {
                if updateItemInChildren(item, children: &childChildren) {
                    children[index].children = childChildren
                    return true
                }
            }
        }
        return false
    }

    /**
     * アイテムをリネームします。
     * - Parameter id: アイテムの ID
     * - Parameter newTitle: 新しいタイトル
     */
    public func renameItem(id: UUID, newTitle: String) {
        guard var item = findItem(id: id)?.item else { return }
        item.title = newTitle
        updateItem(item)
        itemRenamed.send((id, newTitle))
    }

    /**
     * アイテムを削除します。
     * - Parameter id: アイテムの ID
     */
    public func deleteItem(id: UUID) {
        if let index = rootItems.firstIndex(where: { $0.id == id }) {
            rootItems.remove(at: index)
            itemsChanged.send(rootItems)
            itemDeleted.send(id)
            return
        }
        _ = deleteItemFromChildren(id: id, children: &rootItems)
        itemsChanged.send(rootItems)
        itemDeleted.send(id)
    }

    /**
     * 子アイテムを削除します。
     * - Parameter id: 子アイテムの ID
     * - Parameter children: 子アイテムの配列
     * - Returns: 削除が成功したかどうか
     */
    private func deleteItemFromChildren(id: UUID, children: inout [SourceItem]) -> Bool {
        for index in children.indices {
            if children[index].id == id {
                children.remove(at: index)
                return true
            }
            if var childChildren = children[index].children {
                if deleteItemFromChildren(id: id, children: &childChildren) {
                    children[index].children = childChildren.isEmpty ? nil : childChildren
                    return true
                }
            }
        }
        return false
    }

    /**
     * グループアイテムの展開状態を切り替えます。
     * - Parameter id: グループアイテムの ID
     */
    public func toggleExpansion(id: UUID) {
        guard var item = findItem(id: id)?.item, item.hasChildren else { return }
        item.isExpanded.toggle()
        updateItem(item)
    }

    /**
     * グループアイテムを展開します。
     * - Parameter id: グループアイテムの ID
     */
    public func expandItem(id: UUID) {
        guard var item = findItem(id: id)?.item, item.hasChildren, !item.isExpanded else { return }
        item.isExpanded = true
        updateItem(item)
    }

    /**
     * グループアイテムを折りたたみます。
     * - Parameter id: グループアイテムの ID
     */
    public func collapseItem(id: UUID) {
        guard var item = findItem(id: id)?.item, item.hasChildren, item.isExpanded else { return }
        item.isExpanded = false
        updateItem(item)
    }

    /**
     * 新しいアイテムを親アイテムに追加します。
     * - Parameter item: 子アイテム
     * - Parameter parentId: 親アイテムの ID
     */
    public func addItem(_ item: SourceItem, parentId: UUID? = nil) {
        if let parentId {
            _ = addItemToParent(item, parentId: parentId, children: &rootItems)
        } else {
            rootItems.append(item)
        }
        itemsChanged.send(rootItems)
    }

    /**
     * 親アイテムに子アイテムを追加します。
     * - Parameter item: 子アイテム
     * - Parameter parentId: 親アイテムの ID
     * - Parameter children: 子アイテムの配列
     * - Returns: 追加が成功したかどうか
     */
    private func addItemToParent(_ item: SourceItem, parentId: UUID, children: inout [SourceItem]) -> Bool {
        for index in children.indices {
            if children[index].id == parentId {
                if children[index].children == nil {
                    children[index].children = []
                }
                children[index].children?.append(item)
                return true
            }
            if var childChildren = children[index].children {
                if addItemToParent(item, parentId: parentId, children: &childChildren) {
                    children[index].children = childChildren
                    return true
                }
            }
        }
        return false
    }

    // MARK: - Drag & Drop (Tree Move)

    /**
     * アイテムの移動先を表す位置
     */
    public enum SourceListMovePosition: Equatable {
        case beforeSibling(siblingId: UUID)
        case afterSibling(siblingId: UUID)
        case appendToParent(parentId: UUID?)
    }

    /**
     * ドロップ完了後の移動結果
     */
    public struct SourceListItemMoveEvent: Equatable {
        public let itemId: UUID
        public let newParentId: UUID?
        public let newIndex: Int

        public init(itemId: UUID, newParentId: UUID?, newIndex: Int) {
            self.itemId = itemId
            self.newParentId = newParentId
            self.newIndex = newIndex
        }
    }

    /**
     * ツリー内でアイテムを移動します。
     * - Parameters:
     *   - id: 移動するアイテムの ID
     *   - position: 挿入位置
     * - Returns: 移動に成功した場合 `true`
     */
    @discardableResult
    public func moveItem(id: UUID, to position: SourceListMovePosition) -> Bool {
        guard findItem(id: id) != nil,
              canMove(itemId: id, to: position),
              let extracted = extractItem(id: id)
        else { return false }

        let event: SourceListItemMoveEvent? = switch position {
        case let .beforeSibling(siblingId):
            insert(extracted, before: siblingId)
        case let .afterSibling(siblingId):
            insert(extracted, after: siblingId)
        case let .appendToParent(parentId):
            append(extracted, toParent: parentId)
        }

        guard let event else {
            rootItems.append(extracted)
            return false
        }

        itemsChanged.send(rootItems)
        itemsMoved.send(event)
        return true
    }

    /**
     * `potentialAncestorId` の子孫に `itemId` が含まれるかどうかを返します。
     */
    public func isDescendant(itemId: UUID, of potentialAncestorId: UUID) -> Bool {
        guard potentialAncestorId != itemId,
              let ancestor = findItem(id: potentialAncestorId)?.item
        else {
            return false
        }
        return containsDescendant(itemId: itemId, in: ancestor)
    }

    private func canMove(itemId: UUID, to position: SourceListMovePosition) -> Bool {
        switch position {
        case let .beforeSibling(siblingId), let .afterSibling(siblingId):
            guard siblingId != itemId else { return false }
            return !isDescendant(itemId: siblingId, of: itemId)
        case let .appendToParent(parentId):
            guard parentId != itemId else { return false }
            if let parentId {
                return !isDescendant(itemId: parentId, of: itemId)
            }
            return true
        }
    }

    private func containsDescendant(itemId: UUID, in item: SourceItem) -> Bool {
        guard let children = item.children else { return false }
        for child in children {
            if child.id == itemId {
                return true
            }
            if containsDescendant(itemId: itemId, in: child) {
                return true
            }
        }
        return false
    }

    private func extractItem(id: UUID) -> SourceItem? {
        if let index = rootItems.firstIndex(where: { $0.id == id }) {
            return rootItems.remove(at: index)
        }
        return extractItemFromChildren(id: id, children: &rootItems)
    }

    private func extractItemFromChildren(id: UUID, children: inout [SourceItem]) -> SourceItem? {
        for index in children.indices {
            if children[index].id == id {
                return children.remove(at: index)
            }
            if var childChildren = children[index].children,
               let extracted = extractItemFromChildren(id: id, children: &childChildren)
            {
                children[index].children = childChildren.isEmpty ? nil : childChildren
                return extracted
            }
        }
        return nil
    }

    private func insert(_ item: SourceItem, before siblingId: UUID) -> SourceListItemMoveEvent? {
        if let index = rootItems.firstIndex(where: { $0.id == siblingId }) {
            rootItems.insert(item, at: index)
            return SourceListItemMoveEvent(itemId: item.id, newParentId: nil, newIndex: index)
        }
        return insertRelativeToSibling(item, siblingId: siblingId, before: true, children: &rootItems)
    }

    private func insert(_ item: SourceItem, after siblingId: UUID) -> SourceListItemMoveEvent? {
        if let index = rootItems.firstIndex(where: { $0.id == siblingId }) {
            let insertIndex = index + 1
            rootItems.insert(item, at: insertIndex)
            return SourceListItemMoveEvent(itemId: item.id, newParentId: nil, newIndex: insertIndex)
        }
        return insertRelativeToSibling(item, siblingId: siblingId, before: false, children: &rootItems)
    }

    private func insertRelativeToSibling(
        _ item: SourceItem,
        siblingId: UUID,
        before: Bool,
        children: inout [SourceItem]
    ) -> SourceListItemMoveEvent? {
        for index in children.indices {
            if var childChildren = children[index].children {
                if let siblingIndex = childChildren.firstIndex(where: { $0.id == siblingId }) {
                    let insertIndex = before ? siblingIndex : siblingIndex + 1
                    childChildren.insert(item, at: insertIndex)
                    children[index].children = childChildren
                    return SourceListItemMoveEvent(
                        itemId: item.id,
                        newParentId: children[index].id,
                        newIndex: insertIndex
                    )
                }
                if let event = insertRelativeToSibling(
                    item,
                    siblingId: siblingId,
                    before: before,
                    children: &childChildren
                ) {
                    children[index].children = childChildren
                    return event
                }
            }
        }
        return nil
    }

    private func append(_ item: SourceItem, toParent parentId: UUID?) -> SourceListItemMoveEvent? {
        if parentId == nil {
            let newIndex = rootItems.count
            rootItems.append(item)
            return SourceListItemMoveEvent(itemId: item.id, newParentId: nil, newIndex: newIndex)
        }
        guard let parentId else { return nil }
        return appendToParent(item, parentId: parentId, children: &rootItems)
    }

    private func appendToParent(
        _ item: SourceItem,
        parentId: UUID,
        children: inout [SourceItem]
    ) -> SourceListItemMoveEvent? {
        for index in children.indices {
            if children[index].id == parentId {
                if children[index].children == nil {
                    children[index].children = []
                }
                let newIndex = children[index].children?.count ?? 0
                children[index].children?.append(item)
                return SourceListItemMoveEvent(itemId: item.id, newParentId: parentId, newIndex: newIndex)
            }
            if var childChildren = children[index].children,
               let event = appendToParent(item, parentId: parentId, children: &childChildren)
            {
                children[index].children = childChildren
                return event
            }
        }
        return nil
    }
}
