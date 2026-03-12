# 仕様書の起点 (S2J Source List)

本ドキュメントは、Swift Package「S2J Source List」の仕様の**入口**です。
各トピックは以下のドキュメントに分割しています。AI 伴走やメンテ時は、該当する spec を参照してください。

| ドキュメント | 役割 |
|--------------|------|
| [overview.md](./overview.md) | プロジェクトの存在理由・スコープ・共通 SPEC への参照 |
| [architecture.md](./architecture.md) | コード構造と責務（Core/UI/Platform、ファイル配置） |
| [selection_spec.md](./selection_spec.md) | 選択・編集ルール（単一/複数、Command/Shift、コミット/キャンセル） |
| [search_spec.md](./search_spec.md) | 検索マッチング・親子表示ルール |
| [drag_drop_spec.md](./drag_drop_spec.md) | ドラッグ & ドロップの挙動・制約・API |
| [SPEC.md](./SPEC.md) | 要件概要・実装状況サマリ・Backlog・品質評価・Appendix |
| [SPEC_CICD.md](./SPEC_CICD.md) | CI/CD 仕様（ワークフロー・ローカルテスト・カバレッジ） |
| [SPEC_STRUCTURE.md](./SPEC_STRUCTURE.md) | 仕様の細分化方針とベター・プラクティス |

## クイック参照

* **「なぜこのプロジェクトがあるか」** → [overview.md](./overview.md)
* **「コードはどこに何を書くか」** → [architecture.md](./architecture.md)
* **「選択・編集の挙動は？」** → [selection_spec.md](./selection_spec.md)
* **「検索のマッチングルールは？」** → [search_spec.md](./search_spec.md)
* **「D&D の仕様は？」** → [drag_drop_spec.md](./drag_drop_spec.md)
* **「実装状況・Backlog」** → [SPEC.md](./SPEC.md)
* **「CI やローカルテストの仕様」** → [SPEC_CICD.md](./SPEC_CICD.md)
* **「仕様をどう分割するかの方針」** → [SPEC_STRUCTURE.md](./SPEC_STRUCTURE.md)
