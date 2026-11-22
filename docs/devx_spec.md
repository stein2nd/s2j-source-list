# S2J Source List - ドキュメント・開発体験

## 1. 目的 `{@devx:s1}`

README / コードコメントに加え、DocC API Reference と Xcode Preview でホスト開発者が組込みしやすくする方針を定義します。

## 2. 構成 `{@devx:s2}`

| 種別 | 場所 | 生成・閲覧 |
| --- | --- | --- |
| 概要 | [README.md](../README.md) | GitHub |
| 仕様 | [specs.md](./specs.md) ほか `docs/` | GitHub / ローカル |
| DocC | `Sources/S2JSourceList/S2JSourceList.docc/` | `npm run docs:docc` または Xcode DocC アーカイブ |
| シンボル本文 | 各 `Sources/**/*.swift` の `/** */` ドキュメント | DocC が自動取り込み |
| Preview データ | `Sources/S2JSourceList/Preview Content/SourceListPreviewData.swift` | Xcode Canvas |
| Preview ビュー | `Sources/S2JSourceList/Preview Content/S2JSourceListPreviews.swift` | Xcode Canvas |

## 3. DocC `{@devx:s3}`

* カタログ名: `S2JSourceList` (ターゲット名と一致)。
* ランディング: `S2JSourceList.md`、入門: `GettingStarted.md`。
* ローカル HTML 出力: `.build/docs/S2JSourceList/` (`scripts/build-docc.sh`)。

## 4. Xcode Preview `{@devx:s4}`

`S2JSourceListPreviews.swift` が提供するプレビュー:

* `SidebarView` — 検索バー付き、D&D 有効
* `SourceRowView` — 選択行、インライン編集
* `InlineEditorView` — 単体

`SourceListPreviewData` は Preview と `SampleApp` と同型のサンプルツリーを共有します。

## 5. スナップショットとの役割分担 `{@devx:s5-snapshot}`

| 手段 | 目的 | 正本 |
| --- | --- | --- |
| Xcode `#Preview` | 開発中の Canvas 確認 | 本 spec §4 |
| SnapshotTesting (`SourceListSnapshotTests`) | CI 回帰・レンダリング比較 (知覚の許容精度) | [ui_test_spec.md](./ui_test_spec.md) |

プレビュー用サンプルツリー (`SourceListPreviewData`) はスナップショットテストとは別データですが、同じ公開型 (`SidebarView` / `SourceRowView` 等) を対象にします。

## 6. 関連 `{@devx:s5}`

* 実装状況: [status.md](./status.md) §ドキュメント・開発体験
* アーキテクチャー: [architecture.md](./architecture.md)
* CI / npm スクリプト: [SPEC_CICD.md](./SPEC_CICD.md) §3.8 / §4.1.1
* 仕様索引: [specs.md](./specs.md)