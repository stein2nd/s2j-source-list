# S2J Source List — 実装状況

| 項目 | 内容 |
| --- | --- |
| 最終更新 | 2026-11-16 |
| リリース (npm / タグ) | **2.0.15** |
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
| CI / ローカルテスト | [SPEC_CICD.md](./SPEC_CICD.md) |
| コード構成 | [architecture.md](./architecture.md) |

**運用:** マイルストーン完了や完了率の再計算のたびに本ファイルの **最終更新** と下表を更新し、詳細は [SPEC.md §11](./SPEC.md) と同期する。

---

## スナップショット (カテゴリー別) `{@status:s-h005}`

[SPEC.md §11.4](./SPEC.md) と同期した要約 (2026-11-16時点)。

| カテゴリー | 完了率 | 状態 |
| --- | --- | --- |
| コア機能 (階層・選択・検索・編集等) | 98.75% | D&D のみ部分実装 |
| UI コンポーネント | 100% | `SidebarView` ほか |
| データモデル・サービス | 100% | `SourceItem` / `SourceListService` / `SelectionManager` |
| リソース (Localizable) | 50% | `Assets.xcassets` 未 |
| テスト (UT / UI / Snapshot) | 33% | ユニットテストのみ |
| CI/CD | 75% | `swift-test` 直列2ジョブ。Notarize 等は未 |
| ドキュメント | 67% | README + `docs/`。DocC 未 |
| アクセシビリティ | 83% | VoiceOver 済。キーボード、Dynamic Type は部分 |
| **全体 (概算)** | **約90%** | ライブラリとして実用可能 |

## 機能スナップショット `{@status:s-h006}`

| 領域 | 状態 | メモ |
| --- | --- | --- |
| 階層表示・展開/折り畳み | ✅ | `DisclosureGroup` |
| 単一/複数選択 (タップ) | ✅ | `SelectionManager` + 行タップ ([selection_spec](./selection_spec.md) §2.5) |
| Command+Shift / iPad 編集モード複数選択 | ❌ | 将来検討 |
| 検索フィルタ | ✅ | [search_spec](./search_spec.md) |
| インラインリネーム | ✅ | `InlineEditorView` |
| コンテキストメニュー | ✅ | デフォルト + ビルダ |
| ドラッグ & ドロップ | ⚠️ | `allowsDragAndDrop` のみ。`onDrag`/`onDrop` 未 |
| SampleApp (macOS) | ✅ | Periphery 用スキーム |
| GitHub Actions `Swift Test` | ✅ | `test-macos` → `test-ios` 直列 |
| 見出しタグ (`{@doc:slug}`) | ✅ | [specs.md §見出しタグ](./specs.md) |

---

## 直近マイルストーン `{@status:s-h007}`

| 版 | 内容 |
| --- | --- |
| 2.0.13 | CI 直列化、リリースビルドを `test-ios` 末尾に |
| 2.0.14 | 行選択の二重タップ回避 ([#10](https://github.com/stein2nd/s2j-source-list/issues/10))、仕様と実装の同期 |
| (docs) | `docs/status.md` 追加、見出しタグ運用 |

---

## 進行中・短期 Backlog `{@status:s-backlog}`

[SPEC.md §12.1](./SPEC.md) より (優先度高い順)。

| 項目 | 状態 | メモ |
| --- | --- | --- |
| ドラッグ & ドロップ本実装 | 未 | [drag_drop_spec](./drag_drop_spec.md) |
| UI / Snapshot テスト | 未 | SnapshotTesting 想定 |
| Preview Content | 未 | Xcode Preview 用データ |
| DocC API Reference | 未 | コメントはあり |
| テスト・カバレッジ70% 目標 | 進行中 | CI Codecov 送信済み |

---

## 検証・運用 `{@status:s-h008}`

| 手段 | コマンド / 場所 |
| --- | --- |
| ローカル (macOS + 任意 iOS) | `npm run test:local` / `./scripts/test-local.sh` |
| CI | GitHub Actions `Swift Test`、`Lint Docs` |
| Swift 品質 | `npm run lint:swift` |
| ドキュメント | `npm run lint:docs` |

## 関連 `{@status:s-h009}`

* 仕様の入口: [specs.md](./specs.md)
* 要件ハブ: [SPEC.md](./SPEC.md)
