//
//  SelectionManager.swift
//  S2JSourceList
//
//  Created by S2J Source List Generator
//

import Foundation
import Combine
import SwiftUI

/** 
 * ソースリスト項目の選択状態を管理するクラス
 * 単一選択と複数選択の両モード、選択履歴、プログラムによる選択をサポートします。
 */
public final class SelectionManager: ObservableObject {

    /** 
     * 選択モード
     */
    public enum SelectionMode {
        case single
        case multiple
    }

    /** 
     * 現在の選択モード
     */
    @Published public var selectionMode: SelectionMode

    /** 
     * 選択されたアイテムの IDの集合
     */
    @Published public private(set) var selectedItemIds: Set<UUID>

    /** 
     * 選択履歴
     */
    @Published public private(set) var selectionHistory: [UUID]

    /** 
     * 選択履歴の最大サイズ
     */
    public var maxHistorySize: Int = 50

    /** 
     * 選択変更イベントのパブリッシャー
     */
    public let selectionChanged = PassthroughSubject<Set<UUID>, Never>()

    /** 
     * 新しい選択マネージャーを初期化します。
     * - Parameter selectionMode: 選択モード (デフォルトは単一選択)
     */
    public init(selectionMode: SelectionMode = .single) {
        self.selectionMode = selectionMode
        self.selectedItemIds = []
        self.selectionHistory = []
    }

    /** 
     * アイテムを選択します。
     * - Parameter itemId: アイテムの ID
     */
    public func selectItem(_ itemId: UUID) {
        switch selectionMode {
        case .single:
            selectedItemIds = [itemId]
        case .multiple:
            selectedItemIds.insert(itemId)
        }
        addToHistory(itemId)
        selectionChanged.send(selectedItemIds)
    }

    /** 
     * アイテムの選択状態を解除します。
     * - Parameter itemId: アイテムの ID
     */
    public func deselectItem(_ itemId: UUID) {
        selectedItemIds.remove(itemId)
        selectionChanged.send(selectedItemIds)
    }

    /** 
     * アイテムの選択状態を切り替えます。
     * - Parameter itemId: アイテムの ID
     */
    public func toggleSelection(_ itemId: UUID) {
        if selectedItemIds.contains(itemId) {
            deselectItem(itemId)
        } else {
            selectItem(itemId)
        }
    }

    /** 
     * すべての選択をクリアします。
     */
    public func clearSelection() {
        selectedItemIds.removeAll()
        selectionChanged.send(selectedItemIds)
    }

    /** 
     * 複数のアイテムを選択します。
     * - Parameter itemIds: 選択するアイテムの IDの集合
     */
    public func selectItems(_ itemIds: Set<UUID>) {
        guard selectionMode == .multiple else {
            // In single mode, select only the first item
            if let firstId = itemIds.first {
                selectItem(firstId)
            }
            return
        }
        selectedItemIds.formUnion(itemIds)
        if let lastId = itemIds.first {
            addToHistory(lastId)
        }
        selectionChanged.send(selectedItemIds)
    }

    /** 
     * アイテムが選択されているかどうかを返します。
     * - Parameter itemId: アイテムの ID
     * - Returns: アイテムが選択されているかどうか
     */
    public func isSelected(_ itemId: UUID) -> Bool {
        selectedItemIds.contains(itemId)
    }

    /** 
     * 最初に選択されたアイテムの IDを取得します。
     * - Returns: 最初に選択されたアイテムの ID, または nil が選択されていない場合
     */
    public var firstSelectedId: UUID? {
        selectedItemIds.first
    }

    // MARK: - History Management

    /** 
     * 選択履歴にアイテムを追加します。
     * - Parameter itemId: アイテムの ID
     */
    private func addToHistory(_ itemId: UUID) {
        // Remove if already exists
        selectionHistory.removeAll { $0 == itemId }
        // Add to front
        selectionHistory.insert(itemId, at: 0)
        // Trim to max size
        if selectionHistory.count > maxHistorySize {
            selectionHistory = Array(selectionHistory.prefix(maxHistorySize))
        }
    }

    /** 
     * 前の選択を履歴で移動します。
     * - Returns: 前のアイテムの ID, または nil が選択されていない場合
     */
    public func navigateToPrevious() -> UUID? {
        guard selectionHistory.count > 1 else { return nil }
        let previous = selectionHistory[1]
        selectItem(previous)
        return previous
    }

    /** 
     * 次の選択を履歴で移動します。
     * - Returns: 次のアイテムの ID, または nil が選択されていない場合
     */
    public func navigateToNext() -> UUID? {
        guard !selectionHistory.isEmpty, selectionHistory.count > 1 else { return nil }
        // This is a simplified implementation
        // In a full implementation, you'd track forward history
        return nil
    }
}
