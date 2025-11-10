# S2J Source List — 個別仕様書

**Package 名**: `s2j-source-list`

**名称**: S2J Source List

**元リポジトリ**: PXSourceList — [https://github.com/alexrozanski/PXSourceList](https://github.com/alexrozanski/PXSourceList)

**目的**: AppKit (PXSourceList) ベースの階層サイドバー機能を Swift/SwiftUI で再実装し、`s2j-source-list` として Swift Package 提供する。

**対応 OS**: macOS v12.0+ / iPadOS v15.0+

---

## 1. 準拠仕様

本仕様は下記の共通仕様に準拠する。

* `Swift/SwiftUI 共通仕様` (COMMON_SPEC.md) — [https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md)
* `S2J About Window SPEC` の記述スタイルを踏襲。

---

## 2. ゴール (高レベル要件)

1. PXSourceList の機能的要素 (階層表示、アイコン、バッジ、選択、多重選択、コンテキストメニュー、ドラッグ & ドロップ、カスタム行表示) を SwiftUI で再現する。
2. ビジネスロジック (モデル・セレクション管理・データソース) は Swift で実装し、SwiftUI と疎結合にする (Observable / Combine ベース)。
3. macOS と iPadOS 両方に適した API を提供する (UI はプラットフォーム最適化)。
4. SPM (Swift Package Manager) で配布可能なモジュール設計。
5. Accessibility、ローカライズ、テスト、CI を備える。

---

## 3. 非機能要件

* 言語: Swift v5.8+ (プロジェクト開始時の最新安定版に合わせる)
* SwiftUI: Xcode v13+/SwiftUI v3+ 相当の API を利用可能
* ビルド: Xcode Cloud / GitHub Actions サポート
* ライセンス: 元リポジトリに準じる (要確認、互換性がなければ MIT を推奨)
* ドキュメント: README + API ドキュメント (DocC 形式推奨)

---

## 4. プロジェクト構成 (提案)

```
S2JSourceList/
├─ Package.swift
├─ Sources/
│  ├─ S2JSourceList/
│  │   ├─ Core/
│  │   │   ├─ Models/
│  │   │   │   └─ SourceItem.swift
│  │   │   ├─ Services/
│  │   │   │   └─ SourceListService.swift
│  │   │   └─ Selection/
│  │   │       └─ SelectionManager.swift
│  │   ├─ UI/
│  │   │   ├─ Views/
│  │   │   │   ├─ SidebarView.swift
│  │   │   │   ├─ SourceRowView.swift
│  │   │   │   └─ InlineEditorView.swift
│  │   │   └─ Platform/
│  │   │       ├─ macOS/
│  │   │       │   └─ AppKitBridge.swift
│  │   │       └─ iPadOS/
│  │   │           └─ iPadOptimizations.swift
│  │   └─ Utils/
│  │       └─ IconProvider.swift
│  └─ S2JSourceListTests/
├─ Tests/
└─ docs/
    └─ SPEC.md
```

---

## 5. モジュール設計 (公開 API)

### 5.1. 主要型 (例)

* `public struct SourceItem: Identifiable, Equatable` — 表示アイテム (title, icon, badge, children, isEditable, metadata)
* `public final class SourceListService: ObservableObject` — データ供給と永続化用インターフェース (`@Published var rootItems: [SourceItem]`)
* `public final class SelectionManager: ObservableObject` — 選択状態 (単一／複数選択)、選択履歴、プログラム的選択
* `public struct SidebarView: View` — 組込みのサイドバーコンポーネント (カスタマイズポイント多数)
* `public struct SourceRowView: View` — 行のレンダラー (カスタムコンテンツを受け取るために `Content` ジェネリクスを用意)

### 5.2. API ポリシー

* View は可能な限り軽量にして、状態は `SourceListService` / `SelectionManager` 側で管理する。
* カスタマイズは `SidebarView` のイニシャライザ引数や `ViewModifier` で拡張可能にする。

---

## 6. PXSourceList → Swift モデル マッピング (抜粋)

* PXSourceList の `PXSourceListItem` → `SourceItem`

  * title, icon, badge, representedObject, isSelectable, isEditable
* グループ/セクション概念は `children: [SourceItem]?` で表現
* Delegate/Callback (選択/編集/コンテキストメニュー) は Combine の `PassthroughSubject` 系で変換

---

## 7. UI 実装方針 (主要機能)

### 7.1. 階層表示

* 基本は `List` + `DisclosureGroup` / `OutlineGroup` を用いる。
* macOS では `SidebarListStyle()` を基本にし、選択時のフォーカスやアクセントカラーを AppKit に近付ける。

### 7.2. アイコン・バッジ

* `Image` (`systemName` / アセット) と `Text` を組み合わせ、バッジは `ZStack` で重ねる。

### 7.3. 選択 (単一 / 複数)

* `SelectionManager` 経由で `.listSelection()` 互換の API を提供。
* macOS: Command/Shift 多重選択サポート。iPadOS: 編集モードで複数選択。

### 7.4. ドラッグ & ドロップ

* `onDrag` / `onDrop` をラップした高レベル API を提供。
* 必要に応じて AppKit ブリッジを用い、より細かいドロップ挙動を実現。

### 7.5. コンテキストメニュー

* `contextMenu` を利用。アクションは `SourceListService` を通じて実行。

### 7.6. インライン編集 (ラベルのリネーム)

* `TextField` と `isEditing` フラグで行内編集を実装。
* 編集のコミット/キャンセルは `SelectionManager` 経由で通知。

---

## 8. カスタマイズポイント

* `SidebarView` に下記オプションを用意する:
  * `rowContent: (SourceItem) -> AnyView` (カスタム行レンダラー)
  * `indentationWidth`, `iconSize`, `rowHeight`
  * `allowsMultipleSelection`, `allowsDragAndDrop`
  * `searchBar: Bool` (組込み検索)

---

## 9. アクセシビリティとローカライズ

* VoiceOver 用の `accessibilityLabel` / `accessibilityValue` を各行コンポーネントで提供。
* `Localizable.strings` を含め、DocC のローカライズを想定。

---

## 10. テスト戦略

* Unit Tests: モデル (SourceItem)、SelectionManager、Service ロジック
* UI Tests: 主要なユーザー操作 (選択、展開/折り畳み、ドラッグ & ドロップ、編集) を XCTest/UI Test でカバー
* Snapshot Tests (任意): `SwiftUI` レンダリングの一貫性

---

## 11. CI / リリース

* GitHub Actions ワークフロー (macOS runner) で `swift build`, `swift test`, `xcodebuild` を実行
* Tag ルール: `vMAJOR.MINOR.PATCH`
* リリースアセット: ソース + DocC ドキュメント

---

## 12. 互換性と制約事項

* SwiftUI の `OutlineGroup` は AppKit の完全な振る舞いを再現しないため、細かい挙動 (ネイティブの行高さ制御、ドラッグの微調整等) は AppKit ブリッジを使う必要がある。
* iPadOS 側では外部メニューやフォーカスの振る舞いが macOS と異なるため、プラットフォームごとの最適化コードを用意する。

---

## 13. ドキュメント推奨項目

* Quick Start (Swift Package からの導入手順)
* API Reference (DocC)
* カスタマイズガイド (カスタム行、検索、D&D)
* Migration Guide (PXSourceList からの移行)

---

## 14. セキュリティ / プライバシー

* `representedObject` 等に不特定型を入れる場合、外部パッケージに依存するデータの取り扱いに注意 (潜在的な参照保持など)。

---

## 15. 開発ロードマップ (提案)

1. v0.1.0… コアモデル + SidebarView (読み取り専用、展開/折り畳み、選択)
2. v0.2.0… アイコン・バッジ・カスタム行、検索
3. v0.3.0… 編集 (rename)、コンテキストメニュー
4. v0.4.0… ドラッグ & ドロップ、多重選択の強化
5. v1.0.0… ドキュメント整備・安定版リリース

---

## 16. 参考 (移行時の注意)

* PXSourceList の API (Delegate / DataSource) をそのまま公開すると SwiftUI 側で扱いにくいため、Combine ベースの Publisher API に変換することを推奨。
* 既存の Objective-C コードを直接呼び出す方針がある場合は、`AppKitBridge` モジュールを用意して既存コンポーネントをラップする。