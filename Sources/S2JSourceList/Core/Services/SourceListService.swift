//
//  SourceListService.swift
//  S2JSourceList
//
//  Created by S2J Source List Generator
//

import Foundation
import Combine
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
    private func findItemInChildren(id: UUID, parent: SourceItem, children: [SourceItem]?) -> (item: SourceItem, parent: SourceItem)? {
        guard let children = children else { return nil }
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
        if let parentId = parentId {
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
}
