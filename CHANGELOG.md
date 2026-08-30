# S2J Source List - CHANGELOG

## unreleased

## 2.0.4 - 2026-08-31

### Changed

* `@s2j/docs-linter` を ^1.0.22から ^1.0.23に更新
* `README.md` の `Package.swift` 依存指定を v1.0.0 から v2.0.4 に更新

## 2.0.3 - 2026-08-10

### Changed

* `@s2j/docs-linter` を ^1.0.21から ^1.0.22に更新
* `package.json` に `allowScripts` を追加 (`@s2j/docs-linter` の postinstall を許可)

## 2.0.2 - 2026-07-23

### Changed

* `@s2j/docs-linter` を ^1.0.18 から ^1.0.21 に更新

### Fixed

* npm 12+ で `npm install` が Git 依存の取得禁止（`EALLOWGIT`）により失敗する問題を修正
    * `.npmrc` に `allow-git=all` を追加（`@s2j/docs-linter` の間接 GitHub 依存に対応）
    * `legacy-peer-deps=true` を追加

## 2.0.1 - 2026-06-11

### Changed

* `project.yml` の Project Format を Xcode v26.3相当に更新（`projectFormat: xcode16_3` → `objectVersion` 90）
* `lint:docs` の対象に `CHANGELOG.md` を追加
* `README.md` のバッジ表示順を調整

### Fixed

* GitHub Actions（`test-macos` / `test-ios` / `build-release`）が Swift v6.2系で失敗する問題を修正 (#9)
    * runner を `macos-26`、Xcode を `26.5`（Swift v6.3.2+）に統一
    * Swift v6.2系 Xcode へのフォールバック（26.1 / 26.0.1 / 16.4.0等）を削除
    * Xcode Force-select とツールチェーン確認を全 job に追加

## 2.0.0 - 2026-06-11

### Changed

* iPadOS の最小対応バージョンを v15から v17に引き上げ（破壊的変更）
    * `onChange` を iOS 17+/macOS 14+ の新シグネチャに置き換え
* Swift v6.3.x および Xcode v26.5に対応
    * `swift-tools-version` を v6.3に更新
    * `project.yml` の `SWIFT_VERSION` を v6.3、`xcodeVersion` を v26.5に更新

## 1.0.1 - 2026-06-11

### Fixed

* iOS テスト (`test-ios`) の失敗を修正 (#1)
* Xcode プロジェクトでローカライズリソースにアクセスできない問題を修正（`Bundle+Module.swift` を追加）

### Changed

* macOS の最小対応バージョンを v12から v14に引き上げ（破壊的変更）
* `swift-tools-version` を v5.9に統一（s2j-about-window、s2j-cozy-brew と揃えた）
* S2J Docs Linter を git submodule から `@s2j/docs-linter` npm パッケージ運用に切り替え (#6)
    * `lint:docs` を `s2j-docs-linter` コマンドに簡素化
    * `@s2j/docs-linter` を v1.0.18に更新
* Docs Lint CI ワークフローを `docs-lint.yml` に移行（`docs-linter.yml` を削除）
* 仕様書を細分化（`specs.md` を起点に `overview.md`、`architecture.md`、`selection_spec.md`、`search_spec.md`、`drag_drop_spec.md` 等を追加）
* textlint 設定を `.textlintrc.json` にリネームし、VS Code のパスを `${workspaceFolder}` に修正
