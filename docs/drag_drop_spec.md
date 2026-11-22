# S2J Source List - ドラッグ & ドロップ仕様

## 1. 目的 `{@drag-drop:s1}`

本ドキュメントは、階層ソースリストにおけるドラッグ & ドロップ (D & D) の挙動・制約・ホスト API を定義します。

## 2. 現状 `{@drag-drop:s2}`

* `SidebarView` の `allowsDragAndDrop == true` かつ検索バーが空のとき、行に `.draggable` / `.dropDestination` を付与し、同一ツリー内で並び替え・親子移動。
* グループ行へドロップした場合は子の末尾へ追加し、グループを自動展開する。葉行へドロップした場合は兄弟として直後に挿入する。
* `SourceListService.moveItem(id:to:)` と `itemsMoved` でツリー更新とホスト通知。自己・子孫へのドロップは拒否する。
* 複数選択の一括移動、行間の「前」挿入の精密制御、検索フィルター中の D&D は未対応。

## 3. 対象範囲 `{@drag-drop:s3}`

### 3.1. サポートする操作 `{@drag-drop:s3-1}`

| 操作 | 説明 | 優先度 | 実装 |
| --- | --- | --- | --- |
| 同一ツリー内の並び替え | 兄弟間の順序変更、または親子関係の変更 | Must | ✅ 葉行へのドロップは「直後の兄弟」、グループ行は「子として末尾」 |
| 別グループへの移動 | 異なる親の下への移動 | Should | ✅ グループ行へのドロップで子末尾へ移動 |
| 複数項目の一括移動 | Command/Shift で複数選択した項目をまとめて移動 | Could | 未 |

### 3.2. ソース・ターゲット `{@drag-drop:s3-2}`

* **ドラッグソース**: `SourceItem` の行 (`isSelectable` が true の項目)。グループ行もドラッグ可能とするかは将来検討。
* **ドロップターゲット**: 任意の `SourceItem` 行。`hasChildren` の行は子末尾、葉行は兄弟として直後 (`afterSibling`)。専用ドロップゾーンは未実装。
* **検索中**: `showsSearchBar` でフィルター中 (`searchText` 非空) は D&D 修飾子を付けない。

## 4. 制約とルール `{@drag-drop:s4}`

### 4.1. 移動制約 `{@drag-drop:s4-1}`

* ルート直下への移動は、`SourceListService.rootItems` の更新で表現する。
* 自己へのドロップ、および自分の子孫へのドロップは禁止とする (循環参照の防止)。
* UI から利用するドロップ位置 (v1):
  * 葉行ターゲット → `SourceListMovePosition.afterSibling`
  * グループ行ターゲット → `SourceListMovePosition.appendToParent`
* サービス API では追加で `beforeSibling` を利用可能。兄弟の「前」・子の先頭挿入を UI から選ぶ操作は未実装。

### 4.2. 視覚的フィードバック `{@drag-drop:s4-2}`

* ドラッグ中: システムのドラッグプレビューに委ねる (行の半透明は未実装)。
* ドロップ可能なターゲット: ターゲット行にアクセント色の枠 (`RoundedRectangle.stroke`)。
* ドロップターゲット変更時: `SidebarView` の `List` で `dropTargetId` に連動する短いアニメーション。
* ドロップ不可: `moveItem` が `false` を返す。専用カーソルは未実装。

### 4.3. ホストアプリケーションへの通知 `{@drag-drop:s4-3}`

* D&D 完了時に `SourceListService.moveItem(id:to:)` が `rootItems` を更新し、`itemsChanged` と **`itemsMoved`** を発火する。
* `SourceListItemMoveEvent`: `itemId`、`newParentId` (`nil` = ルート)、`newIndex` (親内の0始まりインデックス)。
* ホストは `itemsMoved` を購読して永続化や副作用を行う。プログラム的移動にも同 API を利用可能。

### 4.4. ペイロード `{@drag-drop:s4-4}`

* D&D 用の内部文字列は `SourceListDragDrop` (`Utils/SourceListDragDrop.swift`)。接頭辞 `s2j-source-item:` に `UUID` を連結する。
* SwiftUI: `String` の `.draggable` / `.dropDestination(for: String.self)`。

## 5. 実装方針 `{@drag-drop:s5}`

* `SidebarView` の `SourceListRowDragDropModifier` が行単位で `.draggable` / `.dropDestination` を付与する (SwiftUI Transferable 相当の `String` ペイロード)。
* 細かいドロップ挙動 (行高さ、ドロップゾーンの精度) が必要な場合は、`AppKitBridge` で AppKit を利用することを検討。
* `allowsDragAndDrop == false`、または検索フィルター中は D&D 修飾子を付けない。
* ロジックの正本は `SourceListService` (抽出・挿入・循環参照ガード)。`moveItem` / ペイロードは `SourceListDragDropTests`、D&D 有効な `SidebarView` 見た目は `SourceListSnapshotTests` ([ui_test_spec.md](./ui_test_spec.md))。

## 6. 関連ドキュメント `{@drag-drop:s6}`

* 仕様の入口: [specs.md](./specs.md)
* アーキテクチャー: [architecture.md](./architecture.md)
* 選択ルール: [selection_spec.md](./selection_spec.md)
* 実装状況、Backlog: [SPEC.md](./SPEC.md)
