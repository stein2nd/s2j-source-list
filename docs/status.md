# S2J Source List — 実装状況

| 項目 | 内容 |
| --- | --- |
| 最終更新 | 2026-11-22 |
| リリース (npm / タグ) | **2.0.19** |
| 最小 OS | macOS **14.6** / iPadOS **17.6** ([overview.md](./overview.md)) |

---

## 概要 `{@status:s-h001}`

本ドキュメントは **現時点の実装スナップショット** を一ヵ所で確認するための索引です。完了率の算出根拠、カテゴリー表の全文、Backlog の詳細は持ちません。

## 目的 `{@status:s-h002}`

* カテゴリー別の完了率と **今フォーカスすべき未了** を短時間で把握する。
* [SPEC.md](./SPEC.md) §11・§12を開く前の入口にする。

## 非目標 `{@status:s-h003}`

* 機能仕様・ドメインルールの正文 (→ 各 spec、[SPEC.md](./SPEC.md))。
* リリース履歴の全文 (→ [CHANGELOG.md](../CHANGELOG.md))。
* CI ステップの手順全文 (→ [SPEC_CICD.md](./SPEC_CICD.md))。

## 正本との関係 `{@status:s-h004}`

| トピック | 正本 |
| --- | --- |
| 完了率・カテゴリー表・品質評価 | [SPEC.md §11](./SPEC.md) (`{@spec:s11}`) |
| Backlog、ロードマップ | [SPEC.md §12](./SPEC.md) (`{@spec:s12}`) |
| 選択・編集 | [selection_spec.md](./selection_spec.md) |
| 検索 | [search_spec.md](./search_spec.md) |
| ドラッグ & ドロップ | [drag_drop_spec.md](./drag_drop_spec.md) |
| アクセシビリティ | [accessibility_spec.md](./accessibility_spec.md) |
| CI / ローカルテスト | [SPEC_CICD.md](./SPEC_CICD.md) |
| コード構成 | [architecture.md](./architecture.md) |

**運用:** マイルストーン完了や完了率の再計算のたびに本ファイルの **最終更新** と下表を更新し、詳細は [SPEC.md §11](./SPEC.md) と同期する。

**完了条件列:** 100% 到達用チェックリスト。`[x]` = 満たし済み、`[ ]` = 未。各§のアンカーが正本。実装％は当該§の `[x]` 数 ÷ 全項目数 ([§ゲート外](#status-gates) を除く)。

## 機能一覧 `{@status:s-features}`

| 機能名 | 実装済み/未実装 | 実装％ | 完了条件 (100%) |
| --- | --- | --- | --- |
| 仕様 (`docs/`) | 確定 | 100 | [§仕様・ドキュメント](#status-spec-docs) (5/5) |
| コア Source List (Must) | 実装済み | 100 | [§コア](#status-core) (11/11) |
| プラットフォーム・ローカライズ | 実装済み | 100 | [§プラットフォーム](#status-platform) (4/4) |
| CI ・ユニットテスト | 実装済み | 100 | [§CI・品質](#status-quality-unit) (6/6) |
| ドラッグ & ドロップ | 実装済み | 100 | [§D&D](#status-dnd) (3/3) |
| テスト拡張 (UI / Snapshot) | 実装済み | 100 | [§テスト拡張](#status-quality-ui) (4/4) |
| ドキュメント・開発体験 | 実装済み | 100 | [§ドキュメント](#status-devx) (4/4) |
| アクセシビリティ拡張 | 実装済み | 100 | [§アクセシビリティ](#status-a11y) (3/3) |

**Must 範囲 (上表の先頭4行):** **100%** — SPM ライブラリとしてホストに組込み可能な水準。

**全体 (D&D、拡張テスト等を含む):** チェックリスト **40項目中40項目** = **100%** (下記と [SPEC.md §11.4](./SPEC.md) に対応)。

## 100% 完了条件チェックリスト `{@status:s100}`

[s2j-about-window `docs/status.md`](https://github.com/stein2nd/s2j-about-window/blob/main/docs/status.md) 同型。検証は `npm run test:local` / CI を正本とする ([SPEC_CICD.md](./SPEC_CICD.md))。

### 仕様・ドキュメント `{@status:s-status-spec-docs}`

* [x] [specs.md](./specs.md) 索引とクイック参照
* [x] [status.md](./status.md) による実装状況の入口
* [x] ドメイン spec (`selection_spec` / `search_spec` / `drag_drop_spec` / `accessibility_spec` / `ui_test_spec` / `devx_spec`) と [SPEC.md](./SPEC.md) の整合
* [x] GitHub Actions `Lint Docs` (`docs-lint.yml`)
* [x] 見出しタグ規約と `npm run docs:heading-tags`

### コア Source List (Must) `{@status:s-status-core}`

正本: [SPEC.md §4.6](./SPEC.md)、[architecture.md](./architecture.md)

* [x] `SourceItem` / `SourceListService` / `SelectionManager`
* [x] 階層表示・展開/折り畳み (`SidebarView` + `DisclosureGroup`)
* [x] 単一/複数選択 (タップ、`allowsMultipleSelection` + `toggleSelection`)
* [x] `SidebarView` は `selectionMode` を書き換えない・行選択は `Task { @MainActor … }` ([selection_spec §2.5](./selection_spec.md))
* [x] 検索フィルター ([search_spec](./search_spec.md))
* [x] インラインリネーム (`InlineEditorView`)
* [x] コンテキストメニュー (デフォルト + `contextMenuBuilder`)
* [x] カスタム行 (`customContent`)、アイコン・バッジ (`SourceRowView` / `IconProvider`)
* [x] `Package.swift` — 最小 OS **14.6** / **17.6** ([overview.md](./overview.md))
* [x] 公開 API、使用例 ([README.md](../README.md))

### プラットフォーム・ローカライズ `{@status:s-status-platform}`

* [x] macOS `.listStyle(.sidebar)` と `AppKitBridge`
* [x] iPadOS `.listStyle(.insetGrouped)` と `iPadOptimizations` (定数)
* [x] `en` / `ja` / `Base` の `Localizable.strings`
* [x] `SampleApp` (macOS) と XcodeGen `project.yml` (Periphery スキーム)

### CI、ユニットテスト `{@status:s-ci-status-quality-unit}`

正本: [SPEC_CICD.md](./SPEC_CICD.md)

* [x] Workflow `Swift Test` (`test-macos` → `test-ios` 直列、末尾リリースビルド)
* [x] `./scripts/test-local.sh` / `npm run test:local`
* [x] `SourceItemTests` / `SelectionManagerTests` / `SourceListServiceTests`
* [x] `npm run lint:docs`
* [x] `npm run lint:swift` (SwiftLint / SwiftFormat / Periphery)
* [x] Codecov 送信 (macOS / iOS、`fail_ci_if_error: false` は iOS 側)

### ドラッグ & ドロップ `{@status:s-status-dnd}`

正本: [drag_drop_spec.md](./drag_drop_spec.md)

* [x] `allowsDragAndDrop` パラメータとアクセシビリティ識別子
* [x] `.draggable` / `.dropDestination` によるツリー内移動 ([drag_drop_spec](./drag_drop_spec.md) §5)
* [x] ドロップ完了時の `SourceListService` 更新とホスト向け通知 API (`itemsMoved`)

### テスト拡張 (UI / Snapshot) `{@status:s-status-quality-ui}`

正本: [ui_test_spec.md](./ui_test_spec.md)、[SPEC_CICD.md](./SPEC_CICD.md) (カバレッジ)

* [x] コアロジックのユニットテスト (上記§と重複可)
* [x] 主要操作の UI テスト (macOS / iPadOS) — `SourceListUserFlowTests` / [ui_test_spec.md](./ui_test_spec.md)
* [x] SnapshotTesting による SwiftUI レンダリング検証 (`SourceListSnapshotTests`、`NSHostingController` on macOS)
* [x] テスト・カバレッジ **70%** 以上 — `scripts/check-coverage.sh` / `npm run test:coverage` ([SPEC_CICD.md](./SPEC_CICD.md))

### ドキュメント・開発体験 `{@status:s-status-devx}`

正本: [devx_spec.md](./devx_spec.md)

* [x] README (導入、API 要約)
* [x] 主要 API のコードコメント
* [x] DocC 形式の API Reference (`S2JSourceList.docc`、`npm run docs:docc`)
* [x] Xcode Preview 用 `Preview Content` (`Sources/.../Preview Content/`)

### アクセシビリティ拡張 `{@status:s-status-a11y}`

正本: [accessibility_spec.md](./accessibility_spec.md)

* [x] VoiceOver (`accessibilityLabel` / `accessibilityValue` / `accessibilityHint`)
* [x] キーボードナビゲーション (矢印キーで選択移動・グループ展開/折りたたみ)
* [x] Dynamic Type (テキストスタイル + `@ScaledMetric` によるアイコン・インデント)

## ゲート外・任意 `{@status:s-status-gates}`

**100% 分母外** (未完了でも `Must` 100% は維持)。

| # | 内容 | 備考 |
| --- | --- | --- |
| G1 | Command+クリック / Shift 範囲選択 | [selection_spec §2.3](./selection_spec.md) 将来検討 |
| G2 | iPad 編集モード (Edit mode) による複数選択 UI | 現状はタップトグルのみ |
| G3 | `Assets.xcassets` | SF Symbols 中心で当面不要の可能性 |
| G4 | Xcode Archive / Notarize のリリース自動化 | Artifacts は CI で生成済み |
| G5 | GitHub Actions `workflow_dispatch` 手動起動 | runner 枯渇時の運用改善 ([SPEC_CICD.md §8](./SPEC_CICD.md)) |

**補足:** 上表 [スナップショット](#status-s-h005) の **約90%** は [SPEC.md §11.4](./SPEC.md) のカテゴリー加重。本チェックリストの **約88%** は上記§の機械的な `[x]` 比率。

---

## スナップショット (カテゴリー別) `{@status:s-h005}`

[SPEC.md §11.4](./SPEC.md) と同期した要約 (2026-11-22時点)。完了条件の機械集計は [§100% チェックリスト](#status-s100) を参照。

| カテゴリー | 完了率 | 状態 |
| --- | --- | --- |
| コア機能 (階層・選択・検索・編集等) | 100% | D&D 含むコア Must |
| UI コンポーネント | 100% | `SidebarView` ほか |
| データモデル・サービス | 100% | `SourceItem` / `SourceListService` / `SelectionManager` |
| リソース (Localizable) | 50% | `Assets.xcassets` 未 |
| テスト (UT / UI / Snapshot) | 100% | UT + フロー UT + Snapshot + 行カバレッジ70% ゲート |
| CI/CD | 75% | `swift-test` 直列2ジョブ。Notarize 等は未 |
| ドキュメント | 100% | README + `docs/` + DocC + Preview |
| アクセシビリティ | 100% | VoiceOver / キーボード / Dynamic Type |
| **全体 (概算)** | **100%** | チェックリスト全項目完了 |

## 機能スナップショット `{@status:s-h006}`

| 領域 | 状態 | メモ |
| --- | --- | --- |
| 階層表示・展開/折り畳み | ✅ | `DisclosureGroup` |
| 単一/複数選択 (タップ) | ✅ | `SelectionManager` + 行タップ ([selection_spec](./selection_spec.md) §2.5) |
| Command+Shift / iPad 編集モード複数選択 | ❌ | 将来検討 |
| 検索フィルター | ✅ | [search_spec](./search_spec.md) |
| インラインリネーム | ✅ | `InlineEditorView` |
| コンテキストメニュー | ✅ | デフォルト + ビルダ |
| ドラッグ & ドロップ | ✅ | `allowsDragAndDrop` + `moveItem` / `itemsMoved` |
| SampleApp (macOS) | ✅ | Periphery 用スキーム |
| GitHub Actions `Swift Test` | ✅ | `test-macos` → `test-ios` 直列 |
| 見出しタグ (`{@doc:slug}`) | ✅ | [specs.md §見出しタグ](./specs.md) |

---

## 直近マイルストーン `{@status:s-h007}`

| 版 | 内容 |
| --- | --- |
| 2.0.13 | CI 直列化、リリースビルドを `test-ios` 末尾に |
| 2.0.14 | 行選択の二重タップ回避 ([#10](https://github.com/stein2nd/s2j-source-list/issues/10))、仕様と実装の同期 |
| 2.0.15 | `docs/status.md` 追加、見出しタグ、`docs:heading-tags` |
| 2.0.16 | `status.md` 100% 完了条件チェックリスト、README 見出しタグ、`docs-linter` 1.0.34 |
| 2.0.17 | ドラッグ & ドロップ本実装 (`moveItem` / `itemsMoved`)、仕様同期 |
| 2.0.18 | アクセシビリティ拡張 (キーボード / Dynamic Type / VoiceOver)、`accessibility_spec.md` |
| 2.0.19 | UI / スナップショットテスト、カバレッジ70% ゲート、DocC、Preview Content |

---

## 進行中・短期 Backlog `{@status:s-backlog}`

[SPEC.md §12.1](./SPEC.md) より (優先度高い順)。

| 項目 | 状態 | メモ |
| --- | --- | --- |
| ドラッグ & ドロップ本実装 | 済 | [drag_drop_spec](./drag_drop_spec.md) |
| UI / Snapshot テスト | 済 | [ui_test_spec.md](./ui_test_spec.md) |
| Preview Content | 済 | [devx_spec.md](./devx_spec.md) |
| DocC API Reference | 済 | `S2JSourceList.docc` / `docs:docc` |
| テスト・カバレッジ70% 目標 | 済 | macOS CI で `check-coverage.sh` |

---

## 検証・運用 `{@status:s-h008}`

| 手段 | コマンド / 場所 |
| --- | --- |
| ローカル (macOS + 任意 iOS) | `npm run test:local` / `./scripts/test-local.sh` |
| 行カバレッジ70% ゲート | `npm run test:coverage` / `./scripts/check-coverage.sh` |
| CI | GitHub Actions `Swift Test`、`Lint Docs` |
| Swift 品質 | `npm run lint:swift` |
| ドキュメント | `npm run lint:docs` |
| DocC (HTML) | `npm run docs:docc` / `./scripts/build-docc.sh` |

## 関連 `{@status:s-h009}`

* 仕様の入口: [specs.md](./specs.md)
* 要件ハブ: [SPEC.md](./SPEC.md)
