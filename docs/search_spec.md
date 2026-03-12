<!--
目的：「検索マッチング・親子表示ルール」の明文化
 -->
# 検索仕様 (S2J Source List)

## 1. 目的

本ドキュメントは、ソースリスト内の検索フィルタの挙動を定義します。検索クエリに応じて表示する項目と、親子の可視性のルールを明文化します。

## 2. 検索の有効化

* `SidebarView` の `showsSearchBar == true` の場合に検索バーが表示される。
* 検索テキストは `searchText`（`@State`）で保持し、リアルタイムにフィルタ結果を更新する。

## 3. マッチングルール

### 3.1. マッチ条件

* 検索テキストは**大文字小文字を区別しない**（`lowercased()` で比較）。
* 項目の `title` に検索テキストが**部分一致**したらマッチとする。
* 例: 検索 `"foo"` → `"Foo Bar"`、`"barfoo"` はマッチ。`"Foo"` は `"foo"` と同等。

### 3.2. 階層における表示ルール

| 条件 | 表示するか | 備考 |
|------|------------|------|
| 自身の title がマッチ | ✅ 表示 |  leaf でも group でも表示 |
| 子のいずれかがマッチ | ✅ 表示 | 親も表示し、マッチした子を子孫として表示 |
| 自身も子もマッチしない | ❌ 非表示 | ツリーから除外 |
| 検索テキストが空 | 全件表示 | フィルタなし |

### 3.3. 親の可視性（子がマッチした場合）

* 子孫のいずれかがマッチする親は、**必ず展開状態**とする（`isExpanded = true`）。
* これにより、マッチした子が画面に表示される。
* フィルタ後も階層構造は維持する（親 → 子の関係を保持）。

### 3.4. フィルタの再帰

* `filterItems(_:searchText:)` は再帰的に子を処理する。
* 子配列に対して同様にフィルタを適用し、マッチした子だけを `filteredChildren` として保持する。
* 親がマッチするか、`filteredChildren` が空でない場合に、その親を結果に含める。

## 4. 挙動のまとめ（擬似コード）

```
filterItems(items, searchText):
  if searchText.isEmpty: return items（無変更）
  lowercased = searchText.lowercased()
  for item in items:
    if item.children != nil:
      filteredChildren = filterItems(item.children, searchText)
      if filteredChildren.isEmpty && !item.title.lowercased().contains(lowercased):
        → スキップ（nil）
      else:
        item.children = filteredChildren
        item.isExpanded = true
        return item
    else:
      if item.title.lowercased().contains(lowercased):
        return item
      else:
        → スキップ（nil）
```

## 5. 関連ドキュメント

* 仕様の入口: [specs.md](./specs.md)
* アーキテクチャー: [architecture.md](./architecture.md)
* 選択・編集ルール: [selection_spec.md](./selection_spec.md)
* 実装状況・Backlog: [SPEC.md](./SPEC.md)
