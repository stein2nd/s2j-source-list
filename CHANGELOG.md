# S2J Source List - CHANGELOG

## unreleased

## 2.0.26 - 2026-11-24

### Changed

* `.github/workflows/swift-test.yml` — [s2j-about-window](https://github.com/stein2nd/s2j-about-window) と同型に整理 (`concurrency`、`test-macos` で test + release + Artifacts、`test-ios` はテストのみ・並列)
* `docs/SPEC_CICD.md` — 上記ジョブ構成を同期
* `README.md` の `Package.swift` 依存指定を v2.0.25→ v2.0.26に更新
* DocC `GettingStarted.md` — 同上
* `package.json` — バージョン **2.0.26**

## 2.0.25 - 2026-11-24

### Fixed

* `project.yml` — `xcodegen generate` 後、iOS ターゲットの Signing が macOS 行に見える問題を是正 (`supportedDestinations: [iOS]`、明示的 `SDKROOT` / `SUPPORTED_PLATFORMS`、`CODE_SIGN_STYLE: Manual`)

### Changed

* `project.yml` — macOS / iOS のフレームワーク・ユニットテストにシミュレーター向け署名設定を統一 (`CODE_SIGNING_ALLOWED: NO`、`CODE_SIGN_IDENTITY: ""` 等。`SampleApp` は従来どおり Automatic)
* `docs/SPEC.md` / `docs/architecture.md` — 開発用 Xcode プロジェクトの署名方針を追記 (SPM 正本、`DEVELOPMENT_TEAM` をコミットしない、Signing UI の見え方)
* `README.md` の `Package.swift` 依存指定を v2.0.24→ v2.0.25に更新
* DocC `GettingStarted.md` — 同上
* `package.json` — バージョン **2.0.25**

## 2.0.24 - 2026-11-24

### Changed

* `README.md` — Features 〜ローカルテストを現行実装に同期 (D&D / 検索 / a11y、XcodeGen スキーム、`npm run test:local`、スナップショット運用、`lint:swift` 等)
* `package-lock.json` — npm ロックファイル更新
* `project.yml` — XcodeGen の `name` をパッケージ名 `s2j-source-list` に統一
* `.gitignore` — ローカル用 `*.code-workspace` / `.textlintrc.backup.json` を追加
* `README.md` の `Package.swift` 依存指定を v2.0.23→ v2.0.24に更新
* DocC `GettingStarted.md` — 同上
* CI / `lint:build` / Periphery — 生成 Xcode プロジェクトを `s2j-source-list.xcodeproj` に合わせて参照を更新

## 2.0.23 - 2026-11-22

### Fixed

* CI — `test-ios`: `SourceListSnapshotTests` の iOS 分岐で SwiftUI `.image(perceptualPrecision:layout:)` の引数順を Swift v6準拠に修正
* CI — `record-ui-snapshots`: `actions/upload-artifact@v4` → **v6** (Node.js v20非推奨 Annotation 回避)

### Changed

* `docs/ui_test_spec.md` / `SPEC_CICD.md` / `SPEC.md` / `status.md` — 上記 iOS ビルド要件と Record ワークフローの Actions v6を同期
* `README.md` の `Package.swift` 依存指定を v2.0.22→ v2.0.23に更新
* DocC `GettingStarted.md` — 同上
* Swift ソース — SwiftLint `trailing_newline` / SwiftFormat 整合

## 2.0.22 - 2026-11-22

### Fixed

* CI — `SourceListSnapshotTests` を `macos-26` 参照 PNG 正本に合わせ、`GITHUB_ACTIONS` 上の macOS のみ画像比較
* CI — `test-macos` カバレッジ出力を `llvm-cov export -format=lcov` に変更 (Xcode v26)、`s2j-source-listPackageTests` バイナリ解決のフォールバック
* CI — `test-ios` ビルド失敗 (`SnapshotTesting` 未解決)

### Added

* `.github/workflows/record-ui-snapshots.yml` — 参照 PNG を `macos-26` で再記録 (`workflow_dispatch`)

### Changed

* `SourceListSnapshotTests` — ホスティング固定、`en_US` / Aqua、iOS は XCTSkip
* `project.yml` — `S2JSourceListTests-macOS` / `-iOS` に SPM `swift-snapshot-testing` (`SnapshotTesting`) をリンク
* `scripts/check-coverage.sh` — lcov 集計、`scripts/export-coverage-xml.sh` — `.build/coverage/coverage.lcov` 出力
* `docs/ui_test_spec.md` / `SPEC.md` / `SPEC_CICD.md` / `status.md` ほか — 上記 CI、スナップショット運用を同期
* `README.md` の `Package.swift` 依存指定を v2.0.21→ v2.0.22に更新
* DocC `GettingStarted.md` — 同上

## 2.0.21 - 2026-11-22

### Changed

* `docs/status.md` — リリース **2.0.20**、スナップショット CI 安定化の完了条件、チェックリスト **41/41**、マイルストーン v2.0.20
* `docs/SPEC.md` / `SPEC_CICD.md` / `architecture.md` / `devx_spec.md` / `specs.md` / `SPEC_STRUCTURE.md` — スナップショット許容精度・`__Snapshots__` exclude を `ui_test_spec.md` と同期
* `README.md` の `Package.swift` 依存指定を v2.0.20→ v2.0.21に更新
* DocC `GettingStarted.md` — 同上

## 2.0.20 - 2026-11-22

### Fixed

* CI — `SourceListSnapshotTests` が GitHub Actions で参照 PNG とピクセル不一致になる問題 (`precision` / `perceptualPrecision`、`.colorScheme` ライト固定、`layoutSubtreeIfNeeded`)

### Changed

* `Package.swift` — テストターゲットで `__Snapshots__` を `exclude` し SPM の unhandled ファイル警告を解消
* `docs/ui_test_spec.md` — スナップショット比較の CI 安定化方針を追記

## 2.0.19 - 2026-11-22

### Added

* **テスト拡張** — `SourceListUserFlowTests`、`SourceListSnapshotTests` (macOS: `NSHostingController` + SnapshotTesting)、`swift-snapshot-testing` 依存
* `SourceListKeyboardNavigation` — 矢印キー用ナビロジックの分離と `SourceListKeyboardNavigationTests`
* `SourceListOutline.filterItems` — 検索フィルターのユーティリティ化と `SourceListOutlineTests`
* `AppKitBridgeTests`、その他 UT 拡充 (`IconProvider` / `SelectionManager` / `SourceListService` 等)
* `scripts/check-coverage.sh` / `export-coverage-xml.sh` — `Sources/S2JSourceList` 行カバレッジ **70%** ゲート
* **DocC** — `S2JSourceList.docc`、`scripts/build-docc.sh`、`npm run docs:docc`
* **Xcode Preview** — `Preview Content/` (`SourceListPreviewData`、`S2JSourceListPreviews`)
* `docs/ui_test_spec.md` / `docs/devx_spec.md`

### Changed

* `SidebarView` — 検索フィルターを `SourceListOutline.filterItems` に委譲、キーボード処理を `SourceListKeyboardNavigation` に委譲
* CI (`swift-test.yml`) — カバレッジ XML 出力と `macOS` 70% ゲート
* `docs/status.md` — テスト拡張・開発体験 **100%**、チェックリスト **40/40**
* `docs/` (`SPEC` / `SPEC_CICD` / `architecture` / `specs` ほか) と `README.md` — UI テスト、DocC、Preview を同期
* `package.json` — `test:coverage`、`docs:docc`
* `README.md` の `Package.swift` 依存指定を v2.0.18→ v2.0.19に更新

## 2.0.18 - 2026-11-21

### Added

* `SidebarView` — 矢印キーで選択移動 (↑↓) とグループ展開/折りたたみ (←→)
* `SourceListOutline` — 表示アウトラインの平坦化 (キーボードナビ用)
* `docs/accessibility_spec.md` — VoiceOver / キーボード / Dynamic Type の正本
* `SourceListOutlineTests`、ローカライズキー `SourceList.Accessibility.*` (en/ja)

### Changed

* `SourceRowView` — `@ScaledMetric`、`.font(.body)`、`accessibilityHint` / `accessibilityIdentifier`、グループ行ラベル
* `docs/status.md` — アクセシビリティ拡張の完了条件 **3/3 (100%)**、全体チェックリスト **35/40≈88%**
* `docs/SPEC.md` §4.10 / §11.4、`specs.md`、`architecture.md`、`SPEC_STRUCTURE.md` — a11y 実装を同期
* `README.md` の `Package.swift` 依存指定を v2.0.17→ v2.0.18に更新

## 2.0.17 - 2026-11-21

### Added

* `SourceListService` — `moveItem(id:to:)`、`SourceListMovePosition`、`itemsMoved` / `SourceListItemMoveEvent` (自己・子孫へのドロップは拒否)
* `SidebarView` — `allowsDragAndDrop` かつ検索空のとき `.draggable` / `.dropDestination` でツリー内移動 (グループ行は子末尾+展開、葉行は兄弟直後)
* `SourceListDragDrop` — D&D 用 UUID ペイロード (`s2j-source-item:`)
* `SourceListServiceTests` — 移動・`itemsMoved`・子孫判定のユニットテスト

### Changed

* `docs/` (`drag_drop_spec` / `status` / `SPEC` / `architecture` / `SPEC_STRUCTURE`) と `README.md` — D&D 実装、API、完了率を同期
* `docs/status.md` — ドラッグ & ドロップ完了条件 **3/3 (100%)**
* `README.md` の `Package.swift` 依存指定を v2.0.16→ v2.0.17に更新

### Fixed

* D&D 追加コードの SwiftLint / SwiftFormat (`line_length`、複数行 `guard` / `if`) を満たすよう整形
* Periphery — `SidebarView.dropTargetId` をドロップ先ハイライトのアニメーションで参照

## 2.0.16 - 2026-11-20

### Added

* `docs/status.md` に S2J シリーズ同型の **100% 完了条件チェックリスト** (機能一覧、Must 範囲、ゲート外) を追加

### Changed

* `README.md` の見出しに横断参照タグ `` `{@readme:…}` `` を付与
* 開発依存 `@s2j/docs-linter` を **^1.0.34** に更新
* `README.md` の `Package.swift` 依存指定を v2.0.15→ v2.0.16に更新

## 2.0.15 - 2026-11-16

### Added

* `docs/status.md` を追加し、実装状況の入口 (カテゴリー要約・短期 Backlog 索引) とする
* 見出し横断参照用タグ `` `{@doc:slug}` `` を `docs/` ほか主要 Markdown に付与、`scripts/apply-heading-tags.py` と `npm run docs:heading-tags` を追加

### Changed

* `docs/SPEC_STRUCTURE.md` §4を本リポジトリの実在 spec ファイル構成に合わせて整理し、`status.md` を推奨構成に追加
* `docs/specs.md` / `overview.md` / `architecture.md` / `SPEC.md` から `status.md` に誘導するリンクを追加
* `docs/SPEC.md` (Appendix 最小 OS、`§11.4` ユーティリティ件数) / `selection_spec.md` §2.5 (行選択の `Task` 遅延) を実装に合わせて更新
* `README.md` の `Package.swift` 依存指定を v2.0.14→ v2.0.15に更新

## 2.0.14 - 2026-11-14

### Changed

* `docs/SPEC.md` / `architecture.md` / `selection_spec.md` / `SPEC_CICD.md` を現行実装に合わせて更新 (最小 OS v14.6/17.6、選択 / iPad 複数選択の記述、CI 直列構成)
* `README.md` の `Package.swift` 依存指定を v2.0.13→ v2.0.14に更新

### Fixed

* `SidebarView` の行選択で二重 `onTapGesture` により同フレームで `selectItem` が2回走る問題を修正し、選択を `Task { @MainActor … }` に遅延 ([#10](https://github.com/stein2nd/s2j-source-list/issues/10))

## 2.0.13 - 2026-11-14

### Changed

* GitHub Actions `swift-test.yml` で `test-ios` に `needs: test-macos` を追加し `macos-26` の同時要求を避ける (`macos-26` の長時間キュー待ち対策)
* 独立ジョブ `build-release` を廃止し、リリースビルドと Artifacts アップロードを `test-ios` ジョブ末尾に統合 (macOS / iOS テスト成功が前提)
* `docs/SPEC_CICD.md` を上記2ジョブ直列構成に合わせて更新
* `README.md` の `Package.swift` 依存指定を v2.0.12→ v2.0.13に更新

## 2.0.12 - 2026-11-14

### Changed

* GitHub Actions `swift-test.yml` で `build-release` を独立ジョブに復帰 (`needs: [test-macos, test-ios]`、`s2j-about-window` と同様)
* `docs/SPEC_CICD.md` を3ジョブ構成に更新、`docs/SPEC.md` / `selection_spec.md` の選択モード連携の記述を実装に合わせて修正
* `README.md` の `Package.swift` 依存指定を v2.0.11→ v2.0.12に更新

### Fixed

* `SidebarView` の `onAppear` で `selectionMode` を同期していた処理を削除し、`Publishing changes from within view updates` が残るケースを解消 ([#10](https://github.com/stein2nd/s2j-source-list/issues/10))

## 2.0.11 - 2026-11-14

### Changed

* `SidebarView` の `init` で `SelectionManager.selectionMode` を更新しないよう変更し、初回 `onAppear` で `allowsMultipleSelection` と同期 ([#10](https://github.com/stein2nd/s2j-source-list/issues/10))
* `SampleApp` / `README.md` の利用例で `SelectionManager(selectionMode:)` を `allowsMultipleSelection` に合わせるよう更新
* `package.json` の `lint:swift` に `xcode:generate` を追加し、`xcode:generate` スクリプトを定義
* `docs/` 配下の仕様を現行実装に合わせて更新 (`SPEC.md` の SampleApp、最小 OS v14.6/v17.6、`docs-lint.yml`、`SPEC_CICD.md` の iOS v17.6デフォルトと `lint:swift` 記載、`selection_spec.md` §2.5、`architecture.md` の SampleApp/Periphery、`overview.md` 等)
* `README.md` の `Package.swift` 依存指定を v2.0.10→ v2.0.11に更新

### Fixed

* `SidebarView` 初期化時の `@Published` 更新により SwiftUI の `Publishing changes from within view updates` 警告が出る問題を修正

## 2.0.10 - 2026-11-08

### Changed

* GitHub Actions (`docs-lint.yml`) の `actions/setup-node` を v4→ v5に更新し、Runner を `ubuntu-24.04` に固定、Node.js を v24に統一
* `docs/SPEC_CICD.md` の Docs Lint 実行環境の記述を更新
* `README.md` の `Package.swift` 依存指定を v2.0.9→ v2.0.10に更新

### Fixed

* `lint-docs` の Node.js v20非推奨および `ubuntu-latest` 移行予告の Annotation を解消

## 2.0.9 - 2026-11-08

### Changed

* `package.json` に Swift 向け npm スクリプトを追加 (`lint:swiftlint` / `lint:swiftformat` / `lint:periphery` / `format:swift` / `profile:swift` / `lint:build` / `analyze:swift`)
* `.swiftlint.yml` / `.swiftformat` / `.periphery.yml` / `.swift-version` を追加
* Swift ソースを SwiftFormat で整形し、SwiftLint / Periphery の指摘を解消
* 最小 OS を macOS v14.6、iPadOS v17.6に統一 (`Package.swift` / `project.yml` / `README.md` / `scripts/test-local.sh`、`s2j-about-window` に合わせる)
* `project.yml` を `settings.base` 構成に整理し、Periphery 用の `SampleApp` ターゲットとスキームを追加
* `.periphery.yml` のスキャン対象スキームを `SampleApp` に変更

### Fixed

* XcodeGen 生成時に macOS フレームワークに `PRODUCT_NAME` が入らずモジュール名がずれ、`npm run lint:periphery` が `build-for-testing` で失敗する問題を修正

## 2.0.8 - 2026-11-06

### Changed

* GitHub Actions の `actions/checkout` / `actions/upload-artifact` / `codecov/codecov-action` を Node.js v24対応の v6に更新
* `docs/SPEC_CICD.md` を現行ワークフローに合わせて更新 (`build-release` 統合の背景、Action v6、`macos-26`)
* `README.md` の `Package.swift` 依存指定を v2.0.7→ v2.0.8に更新

## 2.0.7 - 2026-11-06

### Changed

* GitHub Actions `Swift Test` の `build-release` ジョブを `test-macos` に統合 (`macos-26` ランナー利用を3ジョブ→2ジョブに削減)
* `README.md` の `Package.swift` 依存指定を v2.0.6→ v2.0.7に更新

## 2.0.6 - 2026-11-06

### Changed

* `@s2j/docs-linter` を ^1.0.26→ ^1.0.32に更新
* `README.md` の `Package.swift` 依存指定を v2.0.5→ v2.0.6に更新
* `package.json` に `overrides` を追加 (`glob` ^14.0.3、`minimatch` ^11.0.4)

## 2.0.5 - 2026-10-02

### Changed

* `@s2j/docs-linter` を ^1.0.23→ ^1.0.26に更新
* `README.md` の `Package.swift` 依存指定を v2.0.4→ v2.0.5に更新
* `.vscode/settings.json` に `json.schemaDownload.enable` を追加

### Fixed

* 非推奨設定 `npm.enableScriptExplorer` を削除 (NPM Script Explorer は Explorer の Views メニューから利用可能)

## 2.0.4 - 2026-08-31

### Changed

* `@s2j/docs-linter` を ^1.0.22→ ^1.0.23に更新
* `README.md` の `Package.swift` 依存指定を v1.0.0→ v2.0.4に更新

## 2.0.3 - 2026-08-10

### Changed

* `@s2j/docs-linter` を ^1.0.21→ ^1.0.22に更新
* `package.json` に `allowScripts` を追加 (`@s2j/docs-linter` の postinstall を許可)

## 2.0.2 - 2026-07-23

### Changed

* `@s2j/docs-linter` を ^1.0.18→ ^1.0.21に更新

### Fixed

* npm v12+ で `npm install` が Git 依存の取得禁止 (`EALLOWGIT`) により失敗する問題を修正
    * `.npmrc` に `allow-git=all` を追加 (`@s2j/docs-linter` の間接 GitHub 依存に対応)
    * `legacy-peer-deps=true` を追加

## 2.0.1 - 2026-06-11

### Changed

* `project.yml` の Project Format を Xcode v26.3相当に更新 (`projectFormat: xcode16_3` → `objectVersion` 90)
* `lint:docs` の対象に `CHANGELOG.md` を追加
* `README.md` のバッジ表示順を調整

### Fixed

* GitHub Actions (`test-macos` / `test-ios` / `build-release`) が Swift v6.2系で失敗する問題を修正 (#9)
    * runner を `macos-26`、Xcode を `26.5` (Swift v6.3.2+) に統一
    * Swift v6.2系 Xcode へのフォールバック (26.1 / 26.0.1 / 16.4.0等) を削除
    * Xcode Force-select とツールチェーン確認を全 job に追加

## 2.0.0 - 2026-06-11

### Changed

* iPadOS の最小対応バージョンを v15→ v17に引き上げ (破壊的変更)
    * `onChange` を iOS v17+/macOS v14+ の新シグネチャに置き換え
* Swift v6.3.x および Xcode v26.5に対応
    * `swift-tools-version` を v6.3に更新
    * `project.yml` の `SWIFT_VERSION` を v6.3、`xcodeVersion` を v26.5に更新

## 1.0.1 - 2026-06-11

### Fixed

* iOS テスト (`test-ios`) の失敗を修正 (#1)
* Xcode プロジェクトでローカライズリソースにアクセスできない問題を修正 (`Bundle+Module.swift` を追加)

### Changed

* macOS の最小対応バージョンを v12→ v14に引き上げ (破壊的変更)
* `swift-tools-version` を v5.9に統一 (s2j-about-window、s2j-cozy-brew とそろえた)
* S2J Docs Linter を Git submodule から `@s2j/docs-linter` npm パッケージ運用に切り替え (#6)
    * `lint:docs` を `s2j-docs-linter` コマンドに簡素化
    * `@s2j/docs-linter` を v1.0.18に更新
* Docs Lint CI ワークフローを `docs-lint.yml` に移行 (`docs-linter.yml` を削除)
* 仕様書を細分化 (`specs.md` を起点に `overview.md`、`architecture.md`、`selection_spec.md`、`search_spec.md`、`drag_drop_spec.md` 等を追加)
* textlint 設定を `.textlintrc.json` にリネームし、VS Code のパスを `${workspaceFolder}` に修正
