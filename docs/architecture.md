<!--
目的：「コード構造と責務」の明文化
 -->
# アーキテクチャー (S2J Source List)

## 1. 目的

本ドキュメントは、Swift Package「S2J Source List」のコード構造と各ファイルの責務を明文化します。新機能の追加や変更時に「どこに何を書くか」の判断に利用してください。

## 2. 設計方針

* **レイヤー分離**: Core（モデル・サービス・選択管理）と UI（Views・Platform）を分離し、ビジネスロジックは Swift で実装し SwiftUI と疎結合にする（Observable / Combine ベース）。
* **共有ロジック**: `#if canImport(SwiftUI)` および `#if os(macOS)` / `#if os(iOS)` でプラットフォームを分岐。ViewModel 相当のロジックは Core に集約し共通化する。
* **プラットフォーム固有**: macOS は `AppKitBridge` で AppKit カラー取得、iPadOS は `iPadOptimizations` で SwiftUI ネイティブ API のみを使用。
* **カスタマイズ**: `SidebarView` のイニシャライザ引数や ViewModifier で拡張可能にする。

## 3. ディレクトリ・ファイルと責務

```
Sources/S2JSourceList/
├── Core/
│   ├── Models/
│   │   └── SourceItem.swift        # データモデル (title, icon, badge, children, isEditable, metadata)
│   ├── Selection/
│   │   └── SelectionManager.swift  # 選択状態管理 (単一/複数選択、選択履歴、プログラム的選択)
│   └── Services/
│       └── SourceListService.swift # データ供給と永続化用インターフェース、rootItems、rename/expand/collapse
├── UI/
│   ├── Views/
│   │   ├── SidebarView.swift       # メインのサイドバーコンポーネント、検索・展開・コンテキストメニュー
│   │   ├── SourceRowView.swift     # 行のレンダラー、カスタムコンテンツ対応
│   │   └── InlineEditorView.swift  # インライン編集ビュー（リネーム）
│   └── Platform/
│       ├── macOS/
│       │   └── AppKitBridge.swift  # AppKit カラー取得、NSOutlineView 挙動の参考
│       └── iPadOS/
│           └── iPadOptimizations.swift # iPadOS 向け最適化
├── Utils/
│   ├── IconProvider.swift          # アイコン提供ユーティリティ
│   └── Bundle+Module.swift         # Bundle.module の代替実装 (Xcode プロジェクト用)
└── Resources/                      # Localizable.strings (Base, en, ja)
```

| ファイル | 責務 | 関連 spec |
|----------|------|-----------|
| **SourceItem.swift** | 表示アイテムのデータモデル。`Identifiable`, `Equatable`。title、icon、badge、children、isEditable、metadata。 | — |
| **SelectionManager.swift** | 選択状態の管理。単一/複数選択モード、selectedItemIds、selectionHistory、selectItem / deselectItem / toggleSelection。 | [selection_spec.md](./selection_spec.md) |
| **SourceListService.swift** | データ供給。`@Published var rootItems`。renameItem、expandItem、collapseItem。Publisher（itemsChanged, itemRenamed, itemDeleted）提供。 | — |
| **SidebarView.swift** | メイン UI。検索バー、リスト表示、DisclosureGroup による階層、コンテキストメニュー、選択・編集の統合。 | [selection_spec.md](./selection_spec.md), [search_spec.md](./search_spec.md), [drag_drop_spec.md](./drag_drop_spec.md) |
| **SourceRowView.swift** | 行の描画。アイコン・バッジ・ラベル。カスタムコンテンツ（customContent）対応。選択・編集状態の表示。 | — |
| **InlineEditorView.swift** | 行内編集 UI。TextField によるリネーム、コミット/キャンセル。 | [selection_spec.md](./selection_spec.md) |
| **AppKitBridge.swift** | macOS 専用。AppKit のカラー取得、必要に応じて NSOutlineView の挙動を参考にした微調整。 | — |
| **iPadOptimizations.swift** | iPadOS 専用。SwiftUI ネイティブ API のみで構成、編集モード等の最適化。 | — |
| **IconProvider.swift** | SF Symbol / アセットからのアイコン提供。 | — |
| **Bundle+Module.swift** | SwiftPM の `Bundle.module` が使えない Xcode プロジェクト向けの代替実装。 | — |

## 4. 層境界とデータフロー

* **SourceItem ツリー** → `SourceListService.rootItems` が保持。
* **SidebarView** は `SourceListService` と `SelectionManager` を `@ObservedObject` で参照。
* **選択変更** → `SelectionManager.selectionChanged` (PassthroughSubject) でホストへ通知。
* **編集・削除** → `SourceListService` の `renameItem` 等を経由し、必要に応じて Publisher で通知。
* **検索** → `SidebarView` 内の `searchText` でフィルタし、`filteredItems` として表示。詳細は [search_spec.md](./search_spec.md) を参照。

## 5. プラットフォーム分岐のルール

* **macOS のみ**: `AppKitBridge`、`SidebarListStyle()`、`Color(NSColor.xxx)`。
* **iPadOS のみ**: `iPadOptimizations`、`.listStyle(.insetGrouped)`、編集モードによる複数選択。
* **共通**: `SourceItem`、`SourceListService`、`SelectionManager`、`SidebarView` 本体、`SourceRowView`、`InlineEditorView`、検索ロジック。

## 6. 関連ドキュメント

* 仕様の入口: [specs.md](./specs.md)
* プロジェクト概要: [overview.md](./overview.md)
* 要件・実装状況・Backlog: [SPEC.md](./SPEC.md)
* 選択・編集ルール: [selection_spec.md](./selection_spec.md)
* 検索ルール: [search_spec.md](./search_spec.md)
* ドラッグ & ドロップ: [drag_drop_spec.md](./drag_drop_spec.md)
