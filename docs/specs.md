# S2J Source List - 仕様書の起点

本ドキュメントは、Swift Package「S2J Source List」の仕様の **入口** です。
各トピックは以下のドキュメントに分割しています。AI 伴走やメンテナンス時は、該当する spec を参照してください。

| ドキュメント | 役割 |
| --- | --- |
| [overview.md](./overview.md) | プロジェクトの存在理由・スコープ・共通 SPEC への参照 |
| [architecture.md](./architecture.md) | コード構造と責務 (Core/UI/Platform、ファイル配置) |
| [selection_spec.md](./selection_spec.md) | 選択・編集ルール (単一/複数、Command/Shift、コミット/キャンセル) |
| [search_spec.md](./search_spec.md) | 検索マッチング・親子表示ルール |
| [drag_drop_spec.md](./drag_drop_spec.md) | ドラッグ & ドロップの挙動、制約、API |
| [accessibility_spec.md](./accessibility_spec.md) | VoiceOver、キーボード、Dynamic Type |
| [ui_test_spec.md](./ui_test_spec.md) | UI フロー、SnapshotTesting、行カバレッジ70% ゲート |
| [devx_spec.md](./devx_spec.md) | DocC API Reference、Xcode Preview Content |
| [status.md](./status.md) | **実装状況の入口** (スナップショット・短期 Backlog 索引) |
| [SPEC.md](./SPEC.md) | 要件概要、実装状況サマリ、Backlog、品質評価、Appendix |
| [SPEC_CICD.md](./SPEC_CICD.md) | CI/CD 仕様 (ワークフロー・ローカルテスト・カバレッジ) |
| [SPEC_STRUCTURE.md](./SPEC_STRUCTURE.md) | 仕様の細分化方針とベター・プラクティス |

## 見出しタグ (横断参照) `{@specs:heading-tags}`

本リポジトリの Markdown 見出し末尾には、安定参照用のタグ `` `{@<doc>:<slug>}` `` を付けています。

| 要素 | 形式 | 例 |
| --- | --- | --- |
| **タグ** | `` `{@doc:slug}` `` | `` `{@selection:s2-5}` `` |
| **リンク** | `./file.md#doc-slug` | [selection §2.5](./selection_spec.md#selection-s2-5) |

* **doc**: ファイルごとの短いキー (`overview`, `spec`, `spec-cicd`, `selection` 等)。`scripts/add-heading-tags.py` の `DOC_KEYS` を参照。
* **slug**: 節番号付き見出しは `s2-5` のように番号由来。日本語のみの見出しは `scope` 等の英語短縮語。バージョン見出しは `v2-0-14`。
* 見出しの追加・変更後は `python3 scripts/add-heading-tags.py` を再実行し、タグとアンカーをそろえる。

## クイック参照 `{@specs:quick-ref}`

* **なぜこのプロジェクトがあるか** → [overview.md](./overview.md)
* **コードはどこに何を書くか** → [architecture.md](./architecture.md)
* **選択・編集の挙動** → [selection_spec.md](./selection_spec.md)
* **検索のマッチングルール** → [search_spec.md](./search_spec.md)
* **D&D の仕様** → [drag_drop_spec.md](./drag_drop_spec.md)
* **アクセシビリティ** → [accessibility_spec.md](./accessibility_spec.md)
* **UI / スナップショット・テスト** → [ui_test_spec.md](./ui_test_spec.md)
* **DocC / Preview** → [devx_spec.md](./devx_spec.md)
* **実装状況 (一覧)** → [status.md](./status.md)
* **実装状況、Backlog (詳細)** → [SPEC.md](./SPEC.md)
* **CI やローカルテストの仕様** → [SPEC_CICD.md](./SPEC_CICD.md)
* **ローカル Swift lint (SwiftLint / Periphery 等)** → [SPEC_CICD.md §3.8](./SPEC_CICD.md#spec-cicd-s3-8)
* **「仕様をどう分割するかの方針」** → [SPEC_STRUCTURE.md](./SPEC_STRUCTURE.md)
