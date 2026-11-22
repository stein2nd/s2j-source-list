# S2J Source List - SPEC.md (PXSourceList - SwiftUI Port)

## はじめに `{@spec:s-h001}`

* **仕様の入口**: 各仕様の一覧・クイック参照は [specs.md](specs.md) を参照してください。
* **実装状況の入口**: スナップショットは [status.md](status.md)、本章 §11・§12は詳細・正本です。
* 本ドキュメントでは、Swift Package「S2J Source List」の専用仕様を定義します。
* 本ツールの設計は、以下の共通 SPEC に準拠します。
    * [Swift/SwiftUI 共通仕様](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md)
* 以下は、本ツール固有の仕様をまとめたものです。
* CI/CD 関連の仕様については、[SPEC_CICD.md](SPEC_CICD.md) で規定します。

## 1. プロジェクト概要 `{@spec:s1}`

詳細は [overview.md](overview.md) を参照してください。

* 名称: S2J Source List
* Swift Package 名: s2j-source-list
* 元リポジトリ: [PXSourceList](https://github.com/alexrozanski/PXSourceList)
* 目的: AppKit ベースの「PXSourceList」を SwiftUI で再実装します。
* 対応 OS: macOS v14.6以上、iPadOS v17.6以上

---

## 2. 要件ゴール (高レベル要件) `{@spec:s2}`

### 2.1. 機能要件 `{@spec:s2-1}`

1. PXSourceList の機能的要素 (階層表示、アイコン、バッジ、選択、多重選択、コンテキストメニュー、ドラッグ & ドロップ、カスタム行表示) を SwiftUI で再現します。
2. ビジネスロジック (モデル・セレクション管理・データソース) は Swift で実装し、SwiftUI と疎結合にします (Observable / Combine ベース)。
3. macOS と iPadOS 両方に適した API を提供します (UI はプラットフォーム最適化)。
4. SPM (Swift Package Manager) で配布可能なモジュール設計とします。
5. Accessibility、ローカライズ、テスト、CI を備えます。

### 2.2. 非機能要件 `{@spec:s2-2}`

* 言語: Swift v6.3+ (Xcode v26.5に同梱される Swift バージョンに合わせる)
* SwiftUI: Xcode v26.5+/SwiftUI 相当の API を利用可能
* ビルド: Xcode Cloud / GitHub Actions サポート (詳細は [SPEC_CICD.md](SPEC_CICD.md) を参照)
* ライセンス: 元リポジトリに準じる (要確認、互換性がなければ MIT を推奨)
* ドキュメント: README + API ドキュメント (API Reference 形式推奨)

## 3. 準拠仕様 `{@spec:s3}`

### 3.1. 技術スタック `{@spec:s3-1}`

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

### 3.2. 開発ルール `{@spec:s3-2}`

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

### 3.3. 国際化・ローカライズ `{@spec:s3-3}`

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

### 3.4. コーディング規約 `{@spec:s3-4}`

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

### 3.5. デザイン規約 `{@spec:s3-5}`

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

### 3.6. テスト方針 `{@spec:s3-6}`

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。
* CI/CD でのテスト実行に関する詳細な仕様は、[SPEC_CICD.md](./SPEC_CICD.md) で規定します。

## 4. 個別要件 `{@spec:s4}`

* 元リポジトリ (PXSourceList) の Objective-C / AppKit 実装は参考とし、直接利用しません。
* UI は SwiftUI の `List` / `OutlineGroup` / `DisclosureGroup` / `WindowGroup` / `Sheet` を利用します。
* ダークモード対応は、必須です。
* 本プロジェクトは、「Swift Package Manager」によって、Universal Binary 形式の Swift Package ツールとして他アプリケーション (以後、ホスト・アプリケーションと呼称) に組み込まれます。
* ホスト・アプリケーションからは、階層構造を持つサイドバーリストとして表示します。
* 主要機能として、下記を実装します。
    * 階層構造の表示 (展開/折り畳み) (✅ 実装済み)
    * 項目の選択 (単一選択/複数選択) (✅ 実装済み)
    * アイコン・バッジの表示 (✅ 実装済み)
    * ドラッグ & ドロップ (✅ 実装済み — [drag_drop_spec.md](drag_drop_spec.md))
    * コンテキストメニュー (✅ 実装済み)
    * インライン編集 (ラベルのリネーム) (✅ 実装済み)
    * カスタム行表示 (✅ 実装済み)
    * 検索機能 (✅ 実装済み)
* ホスト・アプリケーションは、macOS アプリケーション (または iPadOS アプリケーション) を想定します。
    * macOS の場合は、`SidebarListStyle()` を基本にし、選択時のフォーカスやアクセントカラーを AppKit に近付けます。(✅ 実装済み)
    * iPadOS の場合は、SwiftUI のネイティブ `List` API のみで構成します。(✅ 実装済み)

### 4.1. プラットフォーム固有 API 利用方針 `{@spec:s4-1}`

**実装状況**: ✅ **実装済み** - プラットフォーム固有 API の実装完了

* View は可能な限り軽量にして、状態は `SourceListService` / `SelectionManager` 側で管理します。
* macOS 向けでは、必要に応じて `NSOutlineView` の挙動を参考にしつつ、SwiftUI の `List` / `OutlineGroup` を基本とします。(✅ 実装済み - `AppKitBridge.swift` で AppKit カラーを取得)
* iPadOS 向けでは、`UIViewControllerRepresentable` を利用せず、SwiftUI のネイティブ API のみで構成します。(✅ 実装済み - `iPadOptimizations.swift` で最適化)
* 共有ロジック (ViewModel / モデル) は、すべて `#if canImport(SwiftUI)` ベースで共通化します。(✅ 実装済み)
* カスタマイズは `SidebarView` のイニシャライザ引数や `ViewModifier` で拡張可能にします。

### 4.2. PXSourceList → Swift モデル マッピング (抜粋) `{@spec:s4-2}`

* PXSourceList の `PXSourceListItem` → `SourceItem`
  * title、icon、badge、representedObject、isSelectable、isEditable
* グループ/セクション概念は `children: [SourceItem]?` で表現します。
* Delegate/Callback (選択/編集/コンテキストメニュー) は Combine の `PassthroughSubject` 系で変換します。

### 4.3. 互換性と制約事項 `{@spec:s4-3}`

* SwiftUI の `OutlineGroup` は AppKit の完全な振る舞いを再現しないため、細かい挙動 (ネイティブの行高さ制御、ドラッグの微調整等) は `AppKitBridge` モジュールを使う必要があります。
* 既存の Objective-C コードを直接呼び出す方針がある場合は、`AppKitBridge` モジュールを用意して既存コンポーネントをラップします。
* iPadOS 側では外部メニューやフォーカスの振る舞いが macOS と異なるため、プラットフォームごとの最適化コードを用意します。
* PXSourceList の API (Delegate / DataSource) をそのまま公開すると SwiftUI 側で扱いにくいため、Combine ベースの Publisher API に変換することを推奨します。

### 4.4. モジュール設計 (公開 API) `{@spec:s4-4}`

### 4.4.1. 主要型 (例) `{@spec:s4-4-1}`

* `public struct SourceItem: Identifiable, Equatable` — 表示アイテム (title、icon、badge、children、isEditable、metadata)
* `public final class SourceListService: ObservableObject` — データ供給 (`@Published var rootItems`)。`moveItem(id:to:)`、`itemsMoved` 等 ([drag_drop_spec.md](drag_drop_spec.md))
* `public final class SelectionManager: ObservableObject` — 選択状態 (単一／複数選択)、選択履歴、プログラム的選択
* `public struct SidebarView: View` — 組込みのサイドバーコンポーネント (カスタマイズ・ポイント多数)
* `public struct SourceRowView: View` — 行のレンダラー (カスタム・コンテンツを受け取るために `Content` ジェネリクスを用意)

### 4.5. プロジェクト構成 `{@spec:s4-5}`

コード構造と各ファイルの責務の詳細は [architecture.md](architecture.md) を参照してください。

```
`s2j-source-list`/
├── LICENSE
├── README.md
├── SampleApp.swift  # macOS デモアプリ・Periphery 用 (✅ 実装済み)
├── Package.swift  # Swift Package 定義 (✅ 実装済み)
├── project.yml  # XcodeGen (+ テスト向け swift-snapshot-testing) (✅ 実装済み)
├── .swiftlint.yml / .swiftformat / .periphery.yml / .swift-version  # ローカル Swift 品質チェック (✅)
├┬─ docs/  # 仕様 (`specs.md` が入口)
│　├─ SPEC.md / SPEC_CICD.md / overview.md / architecture.md ほか
├┬─ .github/workflows/
│　├─ docs-lint.yml  # Docs Linter (`npm run lint:docs`) (✅)
│　├─ swift-test.yml  # Swift テスト・カバレッジ (✅)
│　└─ record-ui-snapshots.yml  # UI 参照 PNG 再記録 workflow_dispatch (✅)
├┬─ scripts/
│└─ test-local.sh  # ローカル CI 相当テスト (✅)
├┬─ tools/docs-linter/  # (任意) Docs Linter サブモジュール。通常は npm の `@s2j/docs-linter` を使用
├┬─ Sources/
│└┬─ S2JSourceList/  # メイン・ソースコード
│　├┬─ Core/
│　│├┬─ Models/
│　││└─ SourceItem.swift  # データモデル (✅ 実装済み)
│　│├┬─ Selection/
│　││└─ SelectionManager.swift  # 選択状態管理 (✅ 実装済み)
│　│└┬─ Services/
│　│　└─ SourceListService.swift  # データ供給と永続化用インターフェース (✅ 実装済み)
│　├┬─ UI/
│　│├┬─ Views/
│　││├─ SidebarView.swift  # メインのサイドバーコンポーネント (✅ 実装済み)
│　││├─ SourceRowView.swift  # 行のレンダラー (✅ 実装済み)
│　││└─ InlineEditorView.swift  # インライン編集ビュー (✅ 実装済み)
│　│└┬─ Platform/
│　│　├┬─ macOS/
│　│　│└─ AppKitBridge.swift  # AppKit ブリッジ (必要に応じて) (✅ 実装済み)
│　│　└┬─ iPadOS/
│　│　　└─ iPadOptimizations.swift  # iPadOS 最適化 (✅ 実装済み)
│　├┬─ Utils/
│　│├─ SourceListDragDrop.swift  # D&D 内部ペイロード (✅ 実装済み)
│　│├─ SourceListOutline.swift  # 表示アウトライン・検索フィルター (✅ 実装済み)
│　│├─ SourceListKeyboardNavigation.swift  # 矢印キー用 ID 移動 (✅ 実装済み)
│　│├─ IconProvider.swift  # アイコン提供ユーティリティ (✅ 実装済み)
│　│└─ Bundle+Module.swift  # Bundle.module の代替実装 (Xcode プロジェクト用) (✅ 実装済み)
│　└┬─ Resources/  # リソースファイル
│　　├┬─ Assets.xcassets/  # アセット (⚠️ 未実装 - 必要に応じて追加)
│　　│└─ Contents.json
│　　├─ Base.lproj/Localizable.strings  # ローカライゼーション (✅ 実装済み)
│　　├─ en.lproj/Localizable.strings  # ローカライゼーション (✅ 実装済み)
│　　└─ ja.lproj/Localizable.strings  # ローカライゼーション (✅ 実装済み)
├┬─ Tests/
│└┬─ S2JSourceListTests/  # テストターゲット (swift-snapshot-testing 依存、`exclude: ["__Snapshots__"]`)
│　├─ *Tests.swift  # コア UT (Item, Selection, Service, Outline, Keyboard, D&D, Icon, AppKitBridge 等) (✅)
│　├─ SourceListUserFlowTests.swift  # 主要操作の統合フロー (✅)
│　├─ SourceListSnapshotTests.swift  # SwiftUI スナップショット (✅)
│　└─ __Snapshots__/SourceListSnapshotTests/  # 参照 PNG (リポジトリ上、SPM ターゲット外) (✅)
├── S2JSourceList.docc/  # DocC カタログ (✅)
└── Preview Content/  # Preview データ・#Preview (✅)
```

### 4.6. UI 実装方針 (主要機能) `{@spec:s4-6}`

### 4.6.1. 階層表示 `{@spec:s4-6-1}`

**実装状況**: ✅ **実装済み** - `SidebarView` で `List` + `DisclosureGroup` を使用して実装

* 基本は `List` + `DisclosureGroup` / `OutlineGroup` を用います。
* macOS では `SidebarListStyle()` を基本にし、選択時のフォーカスやアクセントカラーを AppKit に近付けます。

### 4.6.2. アイコン・バッジ `{@spec:s4-6-2}`

**実装状況**: ✅ **実装済み** - `SourceRowView` と `IconProvider` で実装

* `Image` (`systemName` / アセット) と `Text` を組み合わせ、バッジは `ZStack` で重ねます。

### 4.6.3. 選択 (単一 / 複数) `{@spec:s4-6-3}`

**実装状況**: ✅ **実装済み** - `SelectionManager` で単一選択・複数選択を実装

* 詳細は [selection_spec.md](selection_spec.md) を参照してください。
* 現状は `SelectionManager` (`selectItem` / `toggleSelection` 等) と `SidebarView` の行タップで選択状態を更新します。
* macOS / iPadOS 共通: `allowsMultipleSelection == true` のとき行タップでトグル。Command+クリック、Shift+範囲選択、iPad の SwiftUI 編集モード (Edit mode) による複数選択は **未実装** (将来検討。`selection_spec.md` §2.3を参照)。

### 4.6.4. ドラッグ & ドロップ `{@spec:s4-6-4}`

**実装状況**: ✅ **実装済み** — `allowsDragAndDrop` 有効時に同一ツリー内の並び替え・親子移動。正本は [drag_drop_spec.md](drag_drop_spec.md)。

* `SidebarView`: 検索が空のとき行に `.draggable` / `.dropDestination` (内部 `SourceListDragDrop` ペイロード)。
* `SourceListService`: `moveItem(id:to:)`、`itemsMoved` / `SourceListItemMoveEvent`。自己・子孫へのドロップは拒否。
* 未対応: 検索中の D&D、複数選択の一括移動、`beforeSibling` を UI から選ぶ操作、ドラッグ元の半透明。
* 将来、AppKit ブリッジでドロップゾーン精度を上げる余地あり。

### 4.6.5. コンテキストメニュー `{@spec:s4-6-5}`

**実装状況**: ✅ **実装済み** - `SidebarView` で `contextMenu` を使用して実装

* `contextMenu` を利用します。アクションは `SourceListService` を通じて実行します。

### 4.6.6. インライン編集 (ラベルのリネーム) `{@spec:s4-6-6}`

**実装状況**: ✅ **実装済み** - `InlineEditorView` で実装

* 詳細は [selection_spec.md](selection_spec.md) を参照してください。
* `TextField` と `isEditing` フラグで行内編集を実装します。
* 編集のコミット/キャンセルは `SelectionManager` 経由で通知します。

### 4.7. カスタマイズポイント `{@spec:s4-7}`

**実装状況**: ✅ **実装済み** - `SidebarView` のイニシャライザでカスタマイズ可能

* `SidebarView` に下記オプションを用意します:
  * `rowContent: (SourceItem) -> AnyView` (カスタム行レンダラー) (✅ 実装済み - `customRowContent` パラメータ)
  * `indentationWidth`, `iconSize`, `rowHeight` (✅ 実装済み - `indentationWidth`, `iconSize` パラメータ)
  * `allowsMultipleSelection`, `allowsDragAndDrop` (✅ 実装済み — D&D は `drag_drop_spec.md` を参照)
  * `searchBar: Bool` (組込み検索) (✅ 実装済み - `showsSearchBar` パラメータ) — 検索のマッチングルールは [search_spec.md](search_spec.md) を参照

### 4.8. 主要ファイルの実装状況 `{@spec:s4-8}`

* `Package.swift`: Swift Package 定義、リソース設定 (✅ 実装済み)
* `project.yml` : XcodeGen 設定ファイル、macOS/iOS ターゲット定義、プラットフォーム専用スキーム定義、テスト向け `swift-snapshot-testing` パッケージ依存
  * **ターゲット構成**:
    * `S2JSourceList-macOS`: macOS 向けフレームワーク
    * `S2JSourceList-iOS`: iOS 向けフレームワーク
    * `S2JSourceListTests-macOS` / `S2JSourceListTests-iOS`: テストバンドル (依存: `SnapshotTesting`)
  * **スキーム構成**:
    * `S2JSourceList`: 統合スキーム (macOS + iOS)
    * `S2JSourceList-macOS`: macOS 専用スキーム (macOS ターゲットのみ)
    * `S2JSourceList-iOS`: iOS 専用スキーム (iOS ターゲットのみ)
* `SourceItem.swift`: データモデル (title、icon、badge、children、isEditable、metadata) (✅ 実装済み)
* `SourceListService.swift`: データ供給、`moveItem` / `itemsMoved` 含む (✅ 実装済み)
* `SourceListDragDrop.swift`: D&D 内部ペイロード (✅ 実装済み)
* `SelectionManager.swift`: 選択状態 (単一／複数選択)、選択履歴、プログラム的選択 (✅ 実装済み)
* `SidebarView.swift`: メインのサイドバーコンポーネント、カスタマイズポイント (✅ 実装済み)
* `SourceRowView.swift`: 行のレンダラー、カスタムコンテンツ対応 (✅ 実装済み)
* `InlineEditorView.swift`: インライン編集ビュー (✅ 実装済み)
* `AppKitBridge.swift`: AppKit ブリッジ (必要に応じて) (✅ 実装済み)
* `iPadOptimizations.swift`: iPadOS 最適化 (✅ 実装済み)
* `IconProvider.swift`: アイコン提供ユーティリティ (✅ 実装済み)
* `Bundle+Module.swift`: `Bundle.module` の代替実装 (Xcode プロジェクト用) (✅ 実装済み)
* `Resources/Localizable.strings`: 英語・日本語ローカライゼーション (✅ 実装済み)

### 4.9. セキュリティ / プライバシー `{@spec:s4-9}`

* `representedObject` 等に不特定型を入れる場合、外部パッケージに依存するデータの取り扱いに注意します (潜在的な参照保持など)。

### 4.10. アクセシビリティとローカライズ `{@spec:s4-10}`

**実装状況**: ✅ **実装済み** — ローカライズ完了、アクセシビリティ拡張完了 ([accessibility_spec.md](accessibility_spec.md))

* ローカライズ対応は、必須 (英語・日本語) の為、Base、English、Japanese を初期追加します。(✅ 実装済み)
* `Bundle.module` 経由で `Localizable.strings` を読み込みます (SwiftPM の `resources: [.process("Resources")]`)。(✅ 実装済み)
* Xcode プロジェクトで使用する場合、`Bundle+Module.swift` が `Bundle.module` の代替実装を提供します。(✅ 実装済み)
* 文字列キー例: `"SourceList.Empty"`、`"SourceList.Search.Placeholder"`、`"SourceList.Edit.Rename"`、`"SourceList.Edit.Delete"` (✅ 実装済み)
* VoiceOver 用の `accessibilityLabel` / `accessibilityValue` / `accessibilityHint` を各行コンポーネントで提供します。(✅ 実装済み — 詳細は [accessibility_spec.md](accessibility_spec.md))
* キーボード — `SidebarView` のリストで矢印キーによる選択・展開。(✅ 実装済み)
* Dynamic Type — テキストスタイルと `@ScaledMetric` によるアイコン・インデント。(✅ 実装済み)
* `Localizable.strings` を含め、API Reference のローカライズを想定します。

## 5. デザイン規約 `{@spec:s5}`

**実装状況**: ✅ **実装済み** - デザイン規約の実装完了

* ダークモード対応は、必須です。(✅ 実装済み - SwiftUI の標準カラーを使用)
* macOS では `SidebarListStyle()` を基本とし、選択時のフォーカスやアクセントカラーを AppKit に近付けます。(✅ 実装済み - `SidebarView` で `.listStyle(.sidebar)` を使用)
* iPadOS では、SwiftUI のネイティブ `List` API のみで構成します。(✅ 実装済み - `SidebarView` で `.listStyle(.insetGrouped)` を使用)

## 6. 使用方法 `{@spec:s6}`

**実装状況**: ✅ **実装済み** - 使用方法の実装完了

**macOS / iPadOS (共通):**

```swift
import SwiftUI
import S2JSourceList

struct ContentView: View {
    @StateObject private var sourceListService = SourceListService()
    @StateObject private var selectionManager = SelectionManager()
    
    var body: some View {
        SidebarView(
            service: sourceListService,
            selectionManager: selectionManager
        )
    }
}
```

複数選択を有効にする場合は、`allowsMultipleSelection` と `SelectionManager.selectionMode` を一致させてください (推奨: `SelectionManager(selectionMode: .multiple)`)。`SidebarView` は `init` / `onAppear` ともにモードを書き換えません。詳細は [selection_spec.md](./selection_spec.md) §2.5。

---

## 7. ドキュメント推奨項目 `{@spec:s7}`

* Quick Start (Swift Package からの導入手順) — ✅ `S2JSourceList.docc/GettingStarted.md`
* API Reference (DocC) — ✅ `S2JSourceList.docc` / `npm run docs:docc` ([devx_spec.md](./devx_spec.md))
* Xcode Preview — ✅ `Preview Content/`
* カスタマイズ・ガイド (カスタム行、検索、D&D) — ドメイン spec (`docs/*_spec.md`) に分散
* Migration Guide (PXSourceList からの移行) — ⚠️ Backlog

## 8. テスト戦略 `{@spec:s8}`

**実装状況**: ✅ **実装済み** — ユニットテスト、統合 UI フロー、スナップショット、行カバレッジ70% ゲート ([ui_test_spec.md](./ui_test_spec.md))

* **ユニットテスト** (swift test):
    * モデル (SourceItem)、SelectionManager、Service ロジックのユニットテストを実施します。(✅ 実装済み)
* **UI フロー**:
    * 主要なユーザー操作 (選択、展開/折り畳み、移動、リネーム) を `SourceListUserFlowTests` で検証します。(✅ macOS `swift test` / iPadOS `xcodebuild test`)
* **スナップショットテスト**:
    * SwiftUI レンダリングの一貫性を SnapshotTesting で検証します。(✅ `SourceListSnapshotTests` — macOS `NSHostingController` + 画像比較)
    * 実行は GitHub Actions `macos-26` の `test-macos` のみ。参照 PNG は同ランナーで記録した正本。(詳細 [ui_test_spec.md](./ui_test_spec.md) §5)

**UI テスト環境**:

* macOS: `swift test` (ローカルはスナップショット XCTSkip) / CI `swift test` + `__Snapshots__/`
* iPadOS: `S2JSourceList-iOS` + `project.yml` (`SnapshotTesting` リンク、スナップショットは実行時 XCTSkip だがテストターゲットはビルド必須、UT / UI フロー)

**CI/CD でのテスト実行**:

* CI/CD パイプラインで自動的にテストを実行し、テスト・カバレッジを収集します。
* CI/CD でのテスト実行に関する詳細な仕様は、[SPEC_CICD.md](./SPEC_CICD.md) で規定します。

## 9. CI / CD `{@spec:s9}`

CI/CD に関する詳細な仕様は、[SPEC_CICD.md](./SPEC_CICD.md) を参照してください。

本セクションでは、CI/CD の概要のみを記載します。

* 主な機能:
    * GitHub Actions ワークフロー (`.github/workflows/swift-test.yml`): macOS および iOS/iPadOS 向けテスト実行 (✅ 直近の実行で成功)
    * ローカルテスト・スクリプト (`scripts/test-local.sh`): コミット前に CI/CD と同じテストをローカルで実行可能 (✅ 実装済み)
    * ドキュメント品質検証 (`.github/workflows/docs-lint.yml`): Docs Linter による表記揺れ検出 (`ubuntu-24.04` / Node.js v24) (✅ 直近の実行で成功)
    * ローカル Swift 品質チェック (`npm run lint:swift` 等): SwiftLint / SwiftFormat / Periphery (詳細は [SPEC_CICD.md](./SPEC_CICD.md) §3.8)

**実装状況**: ✅ **完全実装済み・テスト成功** - GitHub Actions ワークフローは実装済み、GitHub Actions「Swift Test」「Docs Linter」ワークフローが直近の実行で成功。リリース自動化 (Notarize 等) は未実装です。

## 10. 開発スケジュール (提案) `{@spec:s10}`

1. v0.1.0… コアモデル + SidebarView (読み取り専用、展開/折り畳み、選択)
2. v0.2.0… アイコン、バッジ、カスタム行、検索
3. v0.3.0… 編集 (rename)、コンテキストメニュー
4. v0.4.0… ドラッグ & ドロップ (✅ 基本実装済み)、多重選択の強化 (一部未)
5. v1.0.0… ドキュメント整備・安定版リリース

## 11. 実装状況サマリー `{@spec:s11}`

本章では、「現在の実装状況」を記載します。要約のみ必要な場合は先に [status.md](status.md) を参照してください。

S2J Source List は、当初の仕様の約90%を達成し、本番環境での使用に適した高品質な Swift Package として完成しています。

**主要な成果**:
* **コア機能の完全実装**: 階層表示、選択、編集、検索、コンテキストメニュー、ドラッグ & ドロップなど主要機能は100%実装済み
* **高品質なコード**: Swift、SwiftUI のベスト・プラクティスに準拠
* **優れたユーザー体験**: プラットフォーム固有の最適化と包括的なアクセシビリティ対応
* **堅牢なテスト**: ユニットテストによるコアロジックの検証

### 11.1. 完全実装済み機能 (100% 完了) `{@spec:s11-1}`

* ✅ **階層構造の表示**: 展開/折り畳み機能を `SidebarView` で `DisclosureGroup` を使用して実装
* ✅ **項目の選択**: 単一選択・複数選択を `SelectionManager` で実装
* ✅ **アイコン・バッジの表示**: `SourceRowView` と `IconProvider` で実装
* ✅ **コンテキストメニュー**: `SidebarView` で `contextMenu` を使用して実装
* ✅ **インライン編集**: ラベルのリネーム機能を `InlineEditorView` で実装
* ✅ **カスタム行表示**: `SourceRowView` で `customContent` パラメータをサポート
* ✅ **検索機能**: `SidebarView` で実装
* ✅ **ドラッグ & ドロップ**: `SidebarView` の `allowsDragAndDrop` と `SourceListService.moveItem` / `itemsMoved` で実装
* ✅ **プラットフォーム固有の最適化**: `AppKitBridge` (macOS) と `iPadOptimizations` (iPadOS) で実装
* ✅ **国際化・ローカライズ**: Base、en、ja の `Localizable.strings` を実装
* ✅ **ユニットテスト**: `SourceItemTests`、`SelectionManagerTests`、`SourceListServiceTests` を実装
* ✅ **CI/CD**: GitHub Actions ワークフローとローカルテスト・スクリプトを実装、GitHub Actions「Swift Test」ワークフローが正常に動作し、すべてのテストが成功 (詳細は [SPEC_CICD.md](SPEC_CICD.md) を参照)
* ✅ **主要ファイル**: すべてのコアファイル (`SourceItem`、`SourceListService`、`SelectionManager`、`SidebarView`、`SourceRowView`、`InlineEditorView`、`SourceListDragDrop`、`AppKitBridge`、`iPadOptimizations`、`IconProvider`、`Bundle+Module`) を実装
* ✅ **アクセシビリティ**: VoiceOver / キーボード / Dynamic Type ([accessibility_spec.md](accessibility_spec.md))
* ✅ **ダークモード対応**: SwiftUI の標準カラーを使用して実装

### 11.2. ほとんど実装済み機能 (85-95% 完了) `{@spec:s11-2}`

* (現時点で該当なし — ドラッグ & ドロップは [§11.1](#spec-s11-1) に移行)

### 11.3. 未実装機能 `{@spec:s11-3}`

* ⚠️ **リリース自動化**: Xcode Archive、Notarize、Artifacts 管理、API Reference ドキュメントの提供が未実装です。
* ⚠️ **Assets.xcassets**: 必要に応じて追加する予定ですが、現在は未実装です。

### 11.4. 実装完了率 `{@spec:s11-4}`

本章では、各機能・モジュールごとの詳細な実装完了率を表形式で整理します。

| カテゴリー | 機能・モジュール | 実装状況 | 完了率 | 備考 |
| --- | --- | --- | --- | --- |
| **コア機能** | 階層構造の表示 | ✅ 実装済み | 100% | `SidebarView` で `DisclosureGroup` を使用 |
| | 項目の選択 (単一/複数)  | ✅ 実装済み | 100% | `SelectionManager` で実装 |
| | アイコン・バッジの表示 | ✅ 実装済み | 100% | `SourceRowView` と `IconProvider` で実装 |
| | コンテキストメニュー | ✅ 実装済み | 100% | `SidebarView` で `contextMenu` を使用 |
| | インライン編集 | ✅ 実装済み | 100% | `InlineEditorView` で実装 |
| | カスタム行表示 | ✅ 実装済み | 100% | `SourceRowView` で `customContent` パラメータをサポート |
| | 検索機能 | ✅ 実装済み | 100% | `SidebarView` で実装 |
| | ドラッグ & ドロップ | ✅ 実装済み | 100% | `allowsDragAndDrop` + `moveItem` / `itemsMoved` ([drag_drop_spec](drag_drop_spec.md)) |
| **UI コンポーネント** | `SidebarView` | ✅ 実装済み | 100% | メインのサイドバーコンポーネント |
| | `SourceRowView` | ✅ 実装済み | 100% | 行のレンダラー、カスタムコンテンツ対応 |
| | `InlineEditorView` | ✅ 実装済み | 100% | インライン編集ビュー |
| | `AppKitBridge` (macOS) | ✅ 実装済み | 100% | AppKit カラー取得 |
| | `iPadOptimizations` (iPadOS) | ✅ 実装済み | 100% | iPadOS 最適化 |
| **データモデル** | `SourceItem` | ✅ 実装済み | 100% | データモデル (title, icon, badge, children, isEditable, metadata)  |
| | `SourceListService` | ✅ 実装済み | 100% | データ供給と永続化用インターフェース |
| | `SelectionManager` | ✅ 実装済み | 100% | 選択状態の管理 (単一/複数選択、選択履歴)  |
| **ユーティリティ** | `IconProvider` | ✅ 実装済み | 100% | アイコン提供ユーティリティ |
| | `Bundle+Module` | ✅ 実装済み | 100% | `Bundle.module` の代替実装 (Xcode プロジェクト用) |
| **リソース** | ローカライゼーション (Base/en/ja)  | ✅ 実装済み | 100% | `Localizable.strings` を実装 |
| | `Assets.xcassets` | ⚠️ 未実装 | 0% | 必要に応じて追加予定 |
| **テスト** | ユニットテスト | ✅ 実装済み | 100% | コア + アウトライン + D&D + キーボード等 |
| | UI / フロー | ✅ 実装済み | 100% | `SourceListUserFlowTests` ([ui_test_spec](ui_test_spec.md)) |
| | スナップショットテスト | ✅ 実装済み | 100% | `SourceListSnapshotTests` + `macos-26` 正本・`project.yml` ([ui_test_spec](ui_test_spec.md)) |
| | 行カバレッジ70% | ✅ 実装済み | 100% | `scripts/check-coverage.sh` (CI macOS) |
| **CI/CD** | GitHub Actions ワークフロー | ✅ 実装済み・テスト成功 | 100% | GitHub Actions「Swift Test」ワークフローが正常に動作、詳細は [SPEC_CICD.md](SPEC_CICD.md) を参照 |
| | ローカルテスト・スクリプト | ✅ 実装済み | 100% | 詳細は [SPEC_CICD.md](SPEC_CICD.md) を参照 |
| | リリース自動化 | ⚠️ 未実装 | 0% | Xcode Archive、Notarize、Artifacts 管理が未実装 |
| **ドキュメント** | コードコメント | ✅ 実装済み | 100% | 主要な API にコメントを実装 |
| | API Reference (DocC) | ✅ 実装済み | 100% | `S2JSourceList.docc` ([devx_spec](devx_spec.md)) |
| | README | ✅ 実装済み | 100% | 基本的な使用方法を記載 |
| **アクセシビリティ** | VoiceOver 対応 | ✅ 実装済み | 100% | `accessibilityLabel` / `accessibilityValue` を実装 |
| | キーボードナビゲーション | ✅ 実装済み | 100% | 矢印キーで選択・展開 ([accessibility_spec](accessibility_spec.md)) |
| | 動的タイプ対応 | ✅ 実装済み | 100% | `.body` / `@ScaledMetric` ([accessibility_spec](accessibility_spec.md)) |
| **その他** | `SampleApp.swift` | ✅ 実装済み | 100% | macOS デモ、Periphery 用 (`project.yml` の SampleApp スキーム) |
| | Preview Content | ✅ 実装済み | 100% | `Preview Content/` + `#Preview` ([devx_spec](devx_spec.md)) |
| | `Package.swift` | ✅ 実装済み | 100% | Swift Package 定義、リソース設定 |

**実装完了率の算出方法**:
* 各機能・モジュールの完了率を算出し、カテゴリーごとの平均値を計算
* 全体の実装完了率は、各カテゴリーの完了率を重み付け平均で算出

**カテゴリー別完了率**:
* **コア機能**: 100% (8機能すべて実装済み)
* **UI コンポーネント**: 100% (5コンポーネントすべて実装済み)
* **データモデル**: 100% (3モジュールすべて実装済み)
* **ユーティリティ**: 100% (`IconProvider` / `Bundle+Module` の2モジュール実装済み)
* **リソース**: 50% (ローカライゼーションは実装済み。Assets は未実装)
* **テスト**: 100% (UT / UI フロー / Snapshot / カバレッジゲート)
* **CI/CD**: 80% (ワークフロー、ローカルテスト、macOS カバレッジゲートは実装済み。Notarize 等のリリース自動化は未実装)
* **ドキュメント**: 100% (README、コードコメント、DocC、Preview)
* **アクセシビリティ**: 100% (VoiceOver / キーボード / Dynamic Type)

**全体実装の完了率**: 約 **96%** (チェックリスト項目は [status.md](status.md) で100%。リリース自動化、Assets 等は Backlog)

### 11.5. 品質評価 `{@spec:s11-5}`

* **コード品質**: A (良好) - Swift、SwiftUI のベスト・プラクティスに準拠
* **ユーザビリティ**: A (良好) - プラットフォーム固有の最適化と直感的な UI
* **セキュリティ**: A (良好) - Swift の型安全性と適切なデータ管理
* **パフォーマンス**: A (良好) - 効率的な実装と最適化
* **アクセシビリティ**: A (良好) - VoiceOver 対応と基本的なアクセシビリティ機能を実装
* **保守性**: A (良好) - UT / UI フロー / スナップショットと `Sources/S2JSourceList` 行カバレッジ70% ゲート ([ui_test_spec.md](./ui_test_spec.md))

---

## 12. Backlog `{@spec:s12}`

本章では、「今後の予定」を記載します。

**残りの未実装・部分実装の機能**: リリース自動化、D&D の拡張 (一括移動・検索中 D&D 等)、`Assets.xcassets`。DocC / Preview は [devx_spec.md](./devx_spec.md) で **100%**。

### 12.1. 短期での改善予定 (1-3ヵ月) `{@spec:s12-1}`

以下の機能は、短期間で実装可能な項目です。

1. **ドラッグ & ドロップの拡張** (優先度: 低〜中) (基本は ✅ 完了 — [drag_drop_spec.md](drag_drop_spec.md))
   * 残タスク例: 検索フィルター中の D&D、複数選択の一括移動、`beforeSibling` / 子先頭の UI、`AppKitBridge` による精密ドロップゾーン、ドラッグ元の半透明。

### 12.2. 中期での改善予定 (3-6ヵ月) `{@spec:s12-2}`

1. **GitHub Actions ワークフローの修正** (優先度: 高) (✅ 完了)
   * GitHub Actions ワークフローとローカルテスト・スクリプトの実装を完了しました。
   * 詳細は [SPEC_CICD.md](SPEC_CICD.md) を参照してください。
   
2. **ローカル・テストスクリプトの実装** (優先度: 高) (✅ 完了)
   * ローカルテスト・スクリプトの実装を完了しました。
   * 詳細は [SPEC_CICD.md](SPEC_CICD.md) を参照してください。

3. **SampleApp.swift の実装** (優先度: 中) (✅ 完了)
   * macOS 用 `SampleApp.swift` と XcodeGen の SampleApp スキームを追加しました (v2.0.9以降)。
   * Periphery および手動デモに使用します。

4. **ローカル Swift 品質チェック** (優先度: 中) (✅ 完了)
   * `npm run lint:swift` (SwiftLint / SwiftFormat / Periphery) を導入しました (v2.0.9以降)。
   * 詳細は [SPEC_CICD.md](SPEC_CICD.md) `{@spec-cicd:s3-8}` を参照してください。

5. **リリース自動化の実装** (優先度: 中)
   * 現状: GitHub Actions ワークフローは実装済み、リリース自動化は未実装です。
   * 実装内容:
     * Xcode の Archive を利用したビルド `xcodebuild` (Universal Binary 推奨) を実装します。
     * Notarize / Notarization ステップの自動化スクリプトを実装します。
     * 生成されたリリース用ビルドの Artifacts 管理を実装します。
     * リリース・アセット: ソース + API Reference ドキュメントを提供します。
   * 見積もり: 1-2週間。

5. **Assets.xcassets の追加** (優先度: 低)
   * 現状: 必要に応じて追加する予定です。
   * 実装内容:
     * カスタムアイコンやアセットを追加します。
     * プラットフォーム固有のアセット管理を実装します。
   * 見積もり: 2-3日。

### 12.3. 長期での改善予定 (6ヵ月以上) `{@spec:s12-3}`

以下の機能は、将来の拡張として検討する項目です。

1. **データ永続化機能** (優先度: 低)
   * 実装内容:
     * UserDefaults / Core Data 連携によるデータ永続化を実装します。
     * 展開状態や選択状態の保存・復元を実装します。
   * 見積もり: 2-3週間。

2. **カスタマイズ可能なテーマ・スタイル設定** (優先度: 低)
   * 実装内容:
     * テーマシステムを実装します。
     * カスタムカラー、フォント、スタイルの設定を実装します。
   * 見積もり: 2-3週間。

3. **アニメーション効果の追加** (優先度: 低)
   * 実装内容:
     * 展開/折り畳み時のアニメーションを実装します。
     * 選択時のトランジション効果を実装します。
     * ドラッグ&ドロップ時の視覚的フィードバックをさらに強化します (ドロップ枠・アニメーションは実装済み)。
   * 見積もり: 1-2週間。

4. **アクセシビリティの拡張** (優先度: 低) (基本は ✅ — [accessibility_spec.md](accessibility_spec.md))
   * 残タスク例: `accessibilityRotor`、VoiceOver カスタムアクション、ショートカット表の標準化。

---

## Appendix A: Xcode プロジェクト作成ウィザード推奨選択肢リスト `{@spec:s-appendix-a-xcode}`

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

**補足**:
* 本プロジェクトは Swift Package として他アプリケーションに組み込まれることを前提とするため、Xcode ウィザードで「App」テンプレートを選ぶ必要はありません。
* macOS/iPadOS 両対応の Swift Package として作成する場合は、「Framework」または「Swift Package」テンプレートを使用し、対応プラットフォームを `.macOS("14.6")`、`.iOS("17.6")` と指定します (本リポジトリの `Package.swift` と一致)。
* また、本リポジトリでは npm パッケージ `@s2j/docs-linter` (`npm run lint:docs`) および GitHub Actions `docs-lint.yml` により、ドキュメント品質 (表記揺れや用語統一) を検証します (`tools/docs-linter` サブモジュールは任意)。

### 1. テンプレート選択 `{@spec:s1-2}`

* **Platform**: Multiplatform (macOS、iPadOS)
* **Template**: Framework または Swift Package

### 2. プロジェクト設定 `{@spec:s2-3}`

| 項目 | 推奨値 | 理由 |
| --- | --- | --- |
| Product Name | `s2j-source-list` | `SPEC.md` のプロダクト名と一致 |
| Team | Apple ID に応じて設定 | コード署名のため |
| Organization Identifier | `com.s2j` | ドメイン逆引き規則、一貫性確保 |
| Interface | SwiftUI | SwiftUI ベースを前提 |
| Language | Swift (Swift v6.3) | Xcode v26.5に同梱される Swift バージョン (Objective-C は不要) |
| Use Core Data | Off | データ永続化不要 |
| Include Tests | On | `SPEC.md` にもとづきテストを考慮 |
| Include CloudKit | Off | 不要 |
| Include Document Group | Off | Document-based App ではない |
| Source Control | On (Git) | `SPEC.md` / GitHub 運用をリンクさせるため |

### 3. デプロイ設定 `{@spec:s3-7}`

| 項目 | 推奨値 | 理由 |
| --- | --- | --- |
| macOS Deployment Target | macOS v14.6以上 | `Package.swift` / `project.yml` と一致 (`s2j-about-window` と同一) |
| iOS Deployment Target | iPadOS v17.6以上 | `Package.swift` / `project.yml` と一致 (`s2j-about-window` と同一) |

### 4. 実行確認の環境 (推奨) `{@spec:s4-11}`

| プラットフォーム | 実行確認ターゲット | 理由 |
| --- | --- | --- |
| macOS | macOS v14.6以降 | 最小デプロイターゲットおよび `List` / `OutlineGroup` の動作確認 |
| iPadOS | iPadOS v17.6以降 (iPad Pro シミュレーター等) | 最小デプロイターゲットおよび `List` の UI 挙動確認 |

### 5. CI ワークフロー補足 `{@spec:s5-2}`

**実装状況**: ✅ **実装済み** — `swift-test.yml` に UT / スナップショット・テストと macOS 行カバレッジ70% ゲートを含む ([SPEC_CICD.md](SPEC_CICD.md)、[ui_test_spec.md](./ui_test_spec.md))。

* **重要**: CI/CD 関連の仕様は、[SPEC_CICD.md](SPEC_CICD.md) で規定します。本セクションでは概要のみを記載します。
* 主な機能:
    * GitHub Actions ワークフロー: `docs-lint.yml` (Docs Linter)、`swift-test.yml` (Swift Package テスト)
    * ローカルテスト・スクリプト: `scripts/test-local.sh` (コミット前に CI/CD と同じテストをローカルで実行可能)
    * ローカル Swift 品質チェック: `npm run lint:swift` (詳細は [SPEC_CICD.md](SPEC_CICD.md) §3.8)
