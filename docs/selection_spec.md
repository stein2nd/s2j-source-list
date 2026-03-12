<!--
目的：「選択・編集ルール」の明文化
 -->
# 選択・編集仕様 (S2J Source List)

## 1. 目的

本ドキュメントは、ソースリストにおける**選択**と**インライン編集**のルールを定義します。実装・テストが本 spec に従っているかを検証する際の基準として用います。

## 2. 選択モード

### 2.1. 単一選択モード (`SelectionMode.single`)

* `allowsMultipleSelection == false` の場合に適用。
* 項目をタップ/クリックすると、既存の選択が解除され、当該項目のみが選択される。
* `selectItem(_:)` は `selectedItemIds` を `[itemId]` に置き換える。

### 2.2. 複数選択モード (`SelectionMode.multiple`)

* `allowsMultipleSelection == true` の場合に適用。
* 項目をタップ/クリックすると、当該項目の選択がトグルされる（選択済みなら解除、未選択なら追加）。
* `selectItem(_:)` は `selectedItemIds` に itemId を追加する。
* `toggleSelection(_:)` でオン/オフを切り替える。

### 2.3. プラットフォーム別の入力方法

| プラットフォーム | 複数選択の方法 |
|------------------|----------------|
| **macOS** | Command キー + クリックで追加選択、Shift キー + クリックで範囲選択（将来実装を検討）。現状は `allowsMultipleSelection` が true の場合、タップごとにトグル。 |
| **iPadOS** | 編集モード（Edit mode）で複数選択をサポート。通常モードでは単一選択相当。 |

### 2.4. 選択可能な項目

* `SourceItem.isSelectable == true` の項目のみ選択可能。
* `isSelectable == false` の項目をタップしても選択状態は変化しない。

## 3. 選択履歴

* `selectionHistory` に直近の選択が最大 `maxHistorySize` 件まで保持される（デフォルト 50）。
* 同じ ID が再度選択された場合は履歴内で先頭に移動する（重複は持たない）。
* `navigateToPrevious()` で履歴を遡り、直前の選択に戻る。`navigateToNext()` は将来の拡張用（現状は簡易実装）。

## 4. インライン編集（リネーム）

### 4.1. 編集可能な項目

* `SourceItem.isEditable == true` の項目のみ編集可能。
* コンテキストメニューに「リネーム」が表示されるのは `isEditable` の項目のみ。

### 4.2. 編集の開始・終了

| 操作 | 挙動 |
|------|------|
| **開始** | コンテキストメニューから「リネーム」を選択するか、該当の UX で編集モードに入る。 |
| **コミット** | `SourceListService.renameItem(id:newTitle:)` を呼び出し、成功時に `editingItemId` を nil に戻す。 |
| **キャンセル** | `editingItemId` を nil に戻す。変更は破棄する。 |

### 4.3. 空文字・無効な入力

* リネーム時に空文字が渡された場合は、変更を適用しないか、または事前にバリデーションでエラー表示とする。仕様の詳細は実装側で決定。
* `findItem(id:)` が nil を返す場合（削除済みなど）は、編集を開始しない／中断する。

## 5. プログラム的選択

* `SelectionManager.selectItem(_:)`、`selectItems(_:)`、`clearSelection()` により、コードから選択状態を変更可能。
* `selectionChanged` (PassthroughSubject) で選択変更を購読可能。

## 6. 関連ドキュメント

* 仕様の入口: [specs.md](./specs.md)
* アーキテクチャー: [architecture.md](./architecture.md)
* 検索ルール: [search_spec.md](./search_spec.md)
* 実装状況・Backlog: [SPEC.md](./SPEC.md)
