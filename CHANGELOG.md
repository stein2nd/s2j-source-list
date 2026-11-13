# S2J Source List - CHANGELOG

## unreleased

## 2.0.12 - 2026-11-14

### Changed

* GitHub Actions `swift-test.yml` で `build-release` を独立ジョブに復帰 (`needs: [test-macos, test-ios]`、`s2j-about-window` と同様)
* `docs/SPEC_CICD.md` を 3 ジョブ構成に更新、`docs/SPEC.md` / `selection_spec.md` の選択モード連携の記述を実装に合わせて修正
* `README.md` の `Package.swift` 依存指定を v2.0.11から v2.0.12に更新

### Fixed

* `SidebarView` の `onAppear` で `selectionMode` を同期していた処理を削除し、`Publishing changes from within view updates` が残るケースを解消 ([#10](https://github.com/stein2nd/s2j-source-list/issues/10))

## 2.0.11 - 2026-11-14

### Changed

* `SidebarView` の `init` で `SelectionManager.selectionMode` を更新しないよう変更し、初回 `onAppear` で `allowsMultipleSelection` と同期 ([#10](https://github.com/stein2nd/s2j-source-list/issues/10))
* `SampleApp` / `README.md` の利用例で `SelectionManager(selectionMode:)` を `allowsMultipleSelection` に合わせるよう更新
* `package.json` の `lint:swift` に `xcode:generate` を追加し、`xcode:generate` スクリプトを定義
* `docs/` 配下の仕様を現行実装に合わせて更新 (`SPEC.md` の SampleApp、最小 OS v14.6/v17.6、`docs-lint.yml`、`SPEC_CICD.md` の iOS v17.6デフォルトと `lint:swift` 記載、`selection_spec.md` §2.5、`architecture.md` の SampleApp/Periphery、`overview.md` 等)
* `README.md` の `Package.swift` 依存指定を v2.0.10から v2.0.11に更新

### Fixed

* `SidebarView` 初期化時の `@Published` 更新により SwiftUI の `Publishing changes from within view updates` 警告が出る問題を修正

## 2.0.10 - 2026-11-08

### Changed

* GitHub Actions (`docs-lint.yml`) の `actions/setup-node` を v4から v5に更新し、Runner を `ubuntu-24.04` に固定、Node.js を v24に統一
* `docs/SPEC_CICD.md` の Docs Lint 実行環境の記述を更新
* `README.md` の `Package.swift` 依存指定を v2.0.9から v2.0.10に更新

### Fixed

* `lint-docs` の Node.js v20非推奨および `ubuntu-latest` 移行予告の Annotation を解消

## 2.0.9 - 2026-11-08

### Changed

* `package.json` に Swift 向け npm スクリプトを追加 (`lint:swiftlint` / `lint:swiftformat` / `lint:periphery` / `format:swift` / `profile:swift` / `lint:build` / `analyze:swift`)
* `.swiftlint.yml` / `.swiftformat` / `.periphery.yml` / `.swift-version` を追加
* Swift ソースを SwiftFormat で整形し、SwiftLint / Periphery の指摘を解消
* 最小 OS を macOS v14.6・iPadOS v17.6に統一 (`Package.swift` / `project.yml` / `README.md` / `scripts/test-local.sh`、`s2j-about-window` に合わせる)
* `project.yml` を `settings.base` 構成に整理し、Periphery 用の `SampleApp` ターゲットとスキームを追加
* `.periphery.yml` のスキャン対象スキームを `SampleApp` に変更

### Fixed

* XcodeGen 生成時に macOS フレームワークに `PRODUCT_NAME` が入らずモジュール名がずれ、`npm run lint:periphery` が `build-for-testing` で失敗する問題を修正

## 2.0.8 - 2026-11-06

### Changed

* GitHub Actions の `actions/checkout` / `actions/upload-artifact` / `codecov/codecov-action` を Node.js v24対応の v6に更新
* `docs/SPEC_CICD.md` を現行ワークフローに合わせて更新 (`build-release` 統合の背景、Action v6、`macos-26`)
* `README.md` の `Package.swift` 依存指定を v2.0.7から v2.0.8に更新

## 2.0.7 - 2026-11-06

### Changed

* GitHub Actions `Swift Test` の `build-release` ジョブを `test-macos` に統合 (`macos-26` ランナー利用を3ジョブから2ジョブに削減)
* `README.md` の `Package.swift` 依存指定を v2.0.6から v2.0.7に更新

## 2.0.6 - 2026-11-06

### Changed

* `@s2j/docs-linter` を ^1.0.26から ^1.0.32に更新
* `README.md` の `Package.swift` 依存指定を v2.0.5から v2.0.6に更新
* `package.json` に `overrides` を追加 (`glob` ^14.0.3、`minimatch` ^11.0.4)

## 2.0.5 - 2026-10-02

### Changed

* `@s2j/docs-linter` を ^1.0.23から ^1.0.26に更新
* `README.md` の `Package.swift` 依存指定を v2.0.4から v2.0.5に更新
* `.vscode/settings.json` に `json.schemaDownload.enable` を追加

### Fixed

* 非推奨設定 `npm.enableScriptExplorer` を削除 (NPM Script Explorer は Explorer の Views メニューから利用可能)

## 2.0.4 - 2026-08-31

### Changed

* `@s2j/docs-linter` を ^1.0.22から ^1.0.23に更新
* `README.md` の `Package.swift` 依存指定を v1.0.0から v2.0.4に更新

## 2.0.3 - 2026-08-10

### Changed

* `@s2j/docs-linter` を ^1.0.21から ^1.0.22に更新
* `package.json` に `allowScripts` を追加 (`@s2j/docs-linter` の postinstall を許可)

## 2.0.2 - 2026-07-23

### Changed

* `@s2j/docs-linter` を ^1.0.18から ^1.0.21に更新

### Fixed

* npm 12+ で `npm install` が Git 依存の取得禁止 (`EALLOWGIT`) により失敗する問題を修正
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

* iPadOS の最小対応バージョンを v15から v17に引き上げ (破壊的変更)
    * `onChange` を iOS 17+/macOS 14+ の新シグネチャに置き換え
* Swift v6.3.x および Xcode v26.5に対応
    * `swift-tools-version` を v6.3に更新
    * `project.yml` の `SWIFT_VERSION` を v6.3、`xcodeVersion` を v26.5に更新

## 1.0.1 - 2026-06-11

### Fixed

* iOS テスト (`test-ios`) の失敗を修正 (#1)
* Xcode プロジェクトでローカライズリソースにアクセスできない問題を修正 (`Bundle+Module.swift` を追加)

### Changed

* macOS の最小対応バージョンを v12から v14に引き上げ (破壊的変更)
* `swift-tools-version` を v5.9に統一 (s2j-about-window、s2j-cozy-brew と揃えた)
* S2J Docs Linter を git submodule から `@s2j/docs-linter` npm パッケージ運用に切り替え (#6)
    * `lint:docs` を `s2j-docs-linter` コマンドに簡素化
    * `@s2j/docs-linter` を v1.0.18に更新
* Docs Lint CI ワークフローを `docs-lint.yml` に移行 (`docs-linter.yml` を削除)
* 仕様書を細分化 (`specs.md` を起点に `overview.md`、`architecture.md`、`selection_spec.md`、`search_spec.md`、`drag_drop_spec.md` 等を追加)
* textlint 設定を `.textlintrc.json` にリネームし、VS Code のパスを `${workspaceFolder}` に修正
