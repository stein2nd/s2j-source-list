# SPEC.md (PXSourceList - SwiftUI Port)

## プロジェクト概要

* 名称: S2J Source List
* Swift Package 名: s2j-source-list
* 元リポジトリ: [PXSourceList](https://github.com/alexrozanski/PXSourceList)
* 目的: AppKit ベースの「PXSourceList」を SwiftUI で再実装する
* 対応 OS: macOS v12以上、iPadOS v15以上

**実装状況**: ✅ **実装中** - 主要機能の大部分が実装済み

## 技術スタック

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

## 開発ルール

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

## 国際化・ローカライズ

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

## コーディング規約

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

## デザイン規約

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

## テスト方針

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

## 個別要件

* 元リポジトリ (PXSourceList) の Objective-C / AppKit 実装は参考とし、直接利用しません。
* UI は SwiftUI の `List` / `OutlineGroup` / `DisclosureGroup` を利用します。
* ダークモード対応は、必須です。
* 本プロジェクトは、「Swift Package Manager」によって、Universal Binary 形式の Swift Package ツールとして他アプリケーション (以後、ホスト・アプリケーションと呼称) に組み込まれます。
* ホスト・アプリケーションからは、階層構造を持つサイドバーリストとして表示します。
* 主要機能として、下記を実装します。
    * 階層構造の表示 (展開/折り畳み) (✅ 実装済み)
    * 項目の選択 (単一選択/複数選択) (✅ 実装済み)
    * アイコン・バッジの表示 (✅ 実装済み)
    * ドラッグ & ドロップ (⚠️ 未実装 - パラメータは用意されているが実装未完了)
    * コンテキストメニュー (✅ 実装済み)
    * インライン編集 (ラベルのリネーム) (✅ 実装済み)
    * カスタム行表示 (✅ 実装済み)
    * 検索機能 (✅ 実装済み)
* ホスト・アプリケーションは、macOS アプリケーション (または iPadOS アプリケーション) を想定します。
    * macOS の場合は、`SidebarListStyle()` を基本にし、選択時のフォーカスやアクセントカラーを AppKit に近付けます。(✅ 実装済み)
    * iPadOS の場合は、SwiftUI のネイティブ `List` API のみで構成します。(✅ 実装済み)

### プラットフォーム固有 API 利用方針

**実装状況**: ✅ **実装済み** - プラットフォーム固有 API の実装完了

* macOS 向けでは、必要に応じて `NSOutlineView` の挙動を参考にしつつ、SwiftUI の `List` / `OutlineGroup` を基本とします。(✅ 実装済み - `AppKitBridge.swift` で AppKit カラーを取得)
* iPadOS 向けでは、`UIViewControllerRepresentable` を利用せず、SwiftUI のネイティブ API のみで構成します。(✅ 実装済み - `iPadOptimizations.swift` で最適化)
* 共有ロジック (ViewModel / モデル) は、すべて `#if canImport(SwiftUI)` ベースで共通化します。(✅ 実装済み)

### プロジェクト構成

```
`s2j-source-list`/
├┬─ docs/  # ドキュメント類
│└─ `SPEC01.md`  # 本ドキュメント
├┬─ tools/
│└┬─ docs-linter  # Git サブモジュール『Docs Linter』
│　└┬─ dist/
│　　└─ `run-textlint.js`
├┬─ .github/  # CI/CD
│└┬─ workflows/
│　├─ docs-linter.yml
│　└─ swift-test.yml
├── LICENSE
├── README.md
├── SampleApp.swift  # エントリー・ポイント
├── Package.swift  # Swift Package 定義 (プロジェクト・ファイル兼用) (✅ 実装済み)
├┬─ Sources/
│└┬─ S2JSourceList/  # メイン・ソースコード
│　├─ Core/
│　│  ├─ Models/
│　│  │  └─ SourceItem.swift  # データモデル (✅ 実装済み)
│　│  ├─ Services/
│　│  │  └─ SourceListService.swift  # データ供給と永続化用インターフェース (✅ 実装済み)
│　│  └─ Selection/
│　│     └─ SelectionManager.swift  # 選択状態管理 (✅ 実装済み)
│　├─ UI/
│　│  ├─ Views/
│　│  │  ├─ SidebarView.swift  # メインのサイドバーコンポーネント (✅ 実装済み)
│　│  │  ├─ SourceRowView.swift  # 行のレンダラー (✅ 実装済み)
│　│  │  └─ InlineEditorView.swift  # インライン編集ビュー (✅ 実装済み)
│　│  └─ Platform/
│　│     ├─ macOS/
│　│     │  └─ AppKitBridge.swift  # AppKit ブリッジ (必要に応じて) (✅ 実装済み)
│　│     └─ iPadOS/
│　│        └─ iPadOptimizations.swift  # iPadOS 最適化 (✅ 実装済み)
│　├─ Utils/
│　│  └─ IconProvider.swift  # アイコン提供ユーティリティ (✅ 実装済み)
│　├┬─ Resources/  # リソースファイル
│　│├─ Assets.xcassets/  # アセット (⚠️ 未実装 - 必要に応じて追加)
│　│└┬─ Localizable.strings/  # ローカライゼーション (Base、en、ja、…) (✅ 実装済み)
│　│ ├─ Base.lproj/Localizable.strings (✅ 実装済み)
│　│ ├─ en.lproj/Localizable.strings (✅ 実装済み)
│　│ └─ ja.lproj/Localizable.strings (✅ 実装済み)
├┬─ Tests/
│└┬─ S2JSourceListTests/  # テストコード
│　├─ SourceItemTests.swift (✅ 実装済み)
│　├─ SelectionManagerTests.swift (✅ 実装済み)
│　└─ SourceListServiceTests.swift (✅ 実装済み)
├── UITests/ (⚠️ 未実装)
└── Preview Content/ (⚠️ 未実装)
```

### 2.1. 主要ファイルの実装状況

* `Package.swift` : Swift Package 定義、リソース設定 (✅ 実装済み)
* `SourceItem.swift` : データモデル (title, icon, badge, children, isEditable, metadata) (✅ 実装済み)
* `SourceListService.swift` : データ供給と永続化用インターフェース、`@Published var rootItems: [SourceItem]` (✅ 実装済み)
* `SelectionManager.swift` : 選択状態 (単一／複数選択)、選択履歴、プログラム的選択 (✅ 実装済み)
* `SidebarView.swift` : メインのサイドバーコンポーネント、カスタマイズポイント (✅ 実装済み)
* `SourceRowView.swift` : 行のレンダラー、カスタムコンテンツ対応 (✅ 実装済み)
* `InlineEditorView.swift` : インライン編集ビュー (✅ 実装済み)
* `AppKitBridge.swift` : AppKit ブリッジ (必要に応じて) (✅ 実装済み)
* `iPadOptimizations.swift` : iPadOS 最適化 (✅ 実装済み)
* `IconProvider.swift` : アイコン提供ユーティリティ (✅ 実装済み)
* `Resources/Localizable.strings` : 英語・日本語ローカライゼーション (✅ 実装済み)

### 国際化・ローカライズ

**実装状況**: ✅ **実装済み** - ローカライゼーション対応完了

* ローカライズ対応は、必須 (英語・日本語) の為、Base、English、Japanese を初期追加します。(✅ 実装済み)
* `Bundle.module` 経由で `Localizable.strings` を読み込んでください (SwiftPM の `resources: [.process("Resources")]`)。(✅ 実装済み)
* 文字列キー例: `"SourceList.Empty"`、`"SourceList.Search.Placeholder"`、`"SourceList.Edit.Rename"`、`"SourceList.Edit.Delete"` (✅ 実装済み)

### デザイン規約

**実装状況**: ✅ **実装済み** - デザイン規約の実装完了

* ダークモード対応は、必須です。(✅ 実装済み - SwiftUI の標準カラーを使用)
* macOS では `SidebarListStyle()` を基本とし、選択時のフォーカスやアクセントカラーを AppKit に近付けます。(✅ 実装済み - `SidebarView` で `.listStyle(.sidebar)` を使用)
* iPadOS では、SwiftUI のネイティブ `List` API のみで構成します。(✅ 実装済み - `SidebarView` で `.listStyle(.insetGrouped)` を使用)

### 使用方法

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

### テスト方針

**実装状況**: ✅ **部分実装** - ユニットテストは実装済み、UI テストは未実装

* テスト: モデル (SourceItem)、SelectionManager、Service ロジックのユニットテストを実施します。(✅ 実装済み - `SourceItemTests.swift`、`SelectionManagerTests.swift`、`SourceListServiceTests.swift`)
* UI テスト: 主要なユーザー操作 (選択、展開/折り畳み、ドラッグ & ドロップ、編集) を XCTest / UI Test で検証します。(⚠️ 未実装)
* スナップショットテスト: SwiftUI レンダリングの一貫性を SnapshotTesting で検証します。(⚠️ 未実装)

**UI テスト環境**:
* macOS: `List` を表示し、選択、展開/折り畳み、ドラッグ & ドロップを SnapshotTesting。(⚠️ 未実装)
* iPadOS: `.sheet` 表示を `XCTest` + `ViewInspector` で検証可能とする。(⚠️ 未実装)

### ビルド出力ポリシー

* Swift Package のビルド成果物 (バイナリ / XCFramework) は Git 管理対象外とします。
* Universal Binary 化は SwiftPM のビルドフェーズで自動処理されます。
* リリース用ビルドは GitHub Actions の CI ワークフローで生成し、Artifacts として管理します。

## Appendix A: Xcode プロジェクト作成ウィザード推奨選択肢リスト

* [COMMON_SPEC.md](https://github.com/stein2nd/xcode-common-specs/blob/main/docs/COMMON_SPEC.md) に準拠します。

**補足**:
* 本プロジェクトは Swift Package として他アプリケーションに組み込まれることを前提とするため、Xcode ウィザードで「App」テンプレートを選ぶ必要はありません。
* macOS/iPadOS 両対応の Swift Package として作成する場合は、「Framework」または「Swift Package」テンプレートを使用し、対応プラットフォームを .macOS (.v12)、.iOS (.v15) と指定してください。
* また、本リポジトリでは Git サブモジュール [Docs Linter](https://github.com/stein2nd/docs-linter) を導入し、ドキュメント品質 (表記揺れや用語統一) の検証を CI で実施します。

### 1. テンプレート選択

* **Platform**: Multiplatform (macOS、iPadOS)
* **Template**: Framework または Swift Package

### 2. プロジェクト設定

| 項目 | 推奨値 | 理由 |
|---|---|---|
| Product Name | `s2j-source-list` | `SPEC01.md` のプロダクト名と一致 |
| Team | Apple ID に応じて設定 | コード署名のため |
| Organization Identifier | `com.s2j` | ドメイン逆引き規則、一貫性確保 |
| Interface | SwiftUI | SwiftUI ベースを前提 |
| Language | Swift (Swift v7.0) | Xcode v26.0.1に同梱される Swift バージョン (Objective-C は不要) |
| Use Core Data | Off | データ永続化不要 |
| Include Tests | On | `SPEC01.md` にもとづきテストを考慮 |
| Include CloudKit | Off | 不要 |
| Include Document Group | Off | Document-based App ではない |
| Source Control | On (Git) | `SPEC01.md` / GitHub 運用をリンクさせるため |

### 3. デプロイ設定

| 項目 | 推奨値 | 理由 |
|---|---|---|
| macOS Deployment Target | macOS v12.0以上 | SwiftUI の `List` / `OutlineGroup` API が安定するバージョン |
| iOS Deployment Target | iPadOS v15.0以上 | `.sheet` / `.popover` の SwiftUI API が安定するバージョン |

### 4. 実行確認の環境 (推奨)

| プラットフォーム | 実行確認ターゲット | 理由 |
|---|---|---|
| macOS | macOS v13 (Ventura) 以降 | `List` / `OutlineGroup` の動作確認 |
| iPadOS | iPadOS v16以降 (iPad Pro シミュレータ) | `List` の UI 挙動確認 |

### 5. CI ワークフロー補足

* 本プロジェクトでは、以下の GitHub Actions ワークフローを導入します。
    * `docs-linter.yml`: Markdown ドキュメントの表記揺れ検出 (Docs Linter)
    * `swift-test.yml`: Swift Package のユニットテストおよび UI スナップショットテストの自動実行
* macOS Runner では `swift test --enable-code-coverage` を実行し、テストカバレッジを出力します。
* iPadOS 互換性テストは、`xcodebuild test -scheme S2JSourceList -destination 'platform=iOS Simulator,name=iPad Pro (12.9-inch)'` で検証します。

## Backlog

### 未実装機能

* ドラッグ & ドロップ (⚠️ 未実装 - `SidebarView` に `allowsDragAndDrop` パラメータはあるが、実装未完了)
* UI テスト・スナップショットテストの実装 (⚠️ 未実装)

### 将来の拡張機能

* データ永続化機能 (UserDefaults / Core Data 連携)
* カスタマイズ可能なテーマ・スタイル設定
* アニメーション効果の追加
* アクセシビリティ機能の強化

### 完了した機能

* ✅ 階層構造の表示 (展開/折り畳み) - `SidebarView` で `DisclosureGroup` を使用して実装
* ✅ 項目の選択 (単一選択/複数選択) - `SelectionManager` で実装
* ✅ アイコン・バッジの表示 - `SourceRowView` と `IconProvider` で実装
* ✅ コンテキストメニュー - `SidebarView` で実装
* ✅ インライン編集 (ラベルのリネーム) - `InlineEditorView` で実装
* ✅ カスタム行表示 - `SourceRowView` で `customContent` パラメータをサポート
* ✅ 検索機能 - `SidebarView` で実装
* ✅ プラットフォーム固有の最適化 - `AppKitBridge` (macOS) と `iPadOptimizations` (iPadOS) で実装
* ✅ 国際化・ローカライズ - Base、en、ja の `Localizable.strings` を実装
* ✅ ユニットテスト - `SourceItemTests`、`SelectionManagerTests`、`SourceListServiceTests` を実装
