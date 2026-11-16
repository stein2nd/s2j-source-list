# Swift アプリケーションにおける仕様書の細分化 — ベター・プラクティス

## 1. はじめに `{@spec-structure:s1}`

本ドキュメントでは、[lead-validation-assist](https://github.com/stein2nd/lead-validation-assist) で採用した「仕様の細分化」を、Swift アプリケーション (本リポジトリ **S2J Source List** の `docs/` 構成を例に) どう適用するかを整理します。
目的は **AI 伴走開発** と **後日のメンテナンス** の両方を考慮した、ほどよい粒度の仕様構成です。

---

## 2. なぜ細分化するか (Python と共通の考え方) `{@spec-structure:s2}`

* **検索性**: 変更したいトピック (例: スコア式、アドレス正規化、API 契約) が1ファイルに集約され、AI も人間も「どこを読むか」が明確になる。
* **責務の分離**: 責務 (「なぜこのプロジェクトがあるか」「何を入力/出力とするか」「コードはどこに書くか」) を別ファイルに分けると、仕様の更新が衝突しにくい。
* **テスト・検証との対応**: 数式・ルール・データ定義が独立したドキュメントになっていると、実装やテストを「その仕様に合わせる」形で書きやすい。
* **AI のコンテキスト効率**: 大きな SPEC を毎回渡すより、必要な spec だけを指定して渡すほうがトークン効率も良く、タスクに直結した指示を出しやすい。

Python の lead-validation-assist では、たとえば次のように分けています。

| ファイル | 役割 |
| --- | --- |
| `specs.md` | 仕様の起点 (目次・参照先) |
| `overview.md` | プロジェクトの存在理由の明文化 |
| `scoring_spec.md` | スコア算出ロジックの数式化 |
| `kenall_import_spec.md` | 郵便データ取込と特殊行除外の定義 |
| `data_dictionary.md` | 出力 CSV の列定義の明文化 |
| `architecture.md` | コード構造と責務の明文化 |
| `address_normalization_spec.md` | 住所正規化ルールの厳密定義 |

Swift アプリケーションでも、「何を明文化するか」はドメインに合わせて変えつつ、**同じ考え方**で細分化できます。

---

## 3. Swift アプリケーション向けの細分化の目安 `{@spec-structure:s3}`

「Python スクリプトだから」というより、次の観点で分けると扱いやすいです。

### 3.1. 分離するとよいもの `{@spec-structure:s3-1}`

| 観点 | 内容 | 分離の利点 |
| --- | --- | --- |
| **存在理由・スコープ** | プロジェクトの目的、対象ユーザー、共通 SPEC への参照 | 方針変更時に overview だけ更新すればよい |
| **公開 API の契約** | 型・引数・戻り値・挙動の要約 | ライブラリの場合、利用者と AI の両方が「契約」を一ヵ所で参照できる |
| **ドメインルール** | 数式・ビジネスルール・フォーマット仕様 (例: Markdown の扱い、フォールバック) | 実装・テストが「その spec に従っているか」で検証しやすい |
| **コード構造と責務** | モジュール/ファイル/クラスごとの責務、MVVM 等の方針 | 新機能を「どこに書くか」の判断が AI、人間ともにしやすい |
| **プラットフォーム別挙動** | macOS / iPadOS で何が違うか、`#if os` の意図 | プラットフォーム固有の変更が1ファイルにまとまる |
| **データ・リソース定義** | ローカライズキー一覧、リソースの置き場所・上書き可能性 | 翻訳・リソース追加時に参照する単一の情報源になる |
| **CI/CD** | すでに `SPEC_CICD.md` のように分離済みならそのまま | ビルド・テスト・デプロイの話題がメイン SPEC から分離される |

### 3.2. 無理に分けなくてよいもの `{@spec-structure:s3-2}`

* **実装状況サマリ、Backlog**: 更新頻度が高く、他の仕様と密に連動するため、`SPEC.md` 内のセクションや `implementation_status.md` 1本にまとめておいてもよい。
* **ごく小さいプロジェクト**: ファイル数が少なく、仕様も1本で十分回る場合は、`specs.md` で「起点」だけ用意し、詳細は `SPEC.md` に残す形でもよい。

### 3.3. AI 伴走・メンテナンスの観点でのポイント `{@spec-structure:s3-3}`

* **仕様の起点を1つにする**: `docs/specs.md` で「どの spec が何を担当するか」を一覧にし、AI や新規参加者に「まずここを見る」と案内できるようにする。
* **1ファイル、1テーマ**: 関心 (「API の契約」「Markdown の扱い」「コード構造」) ごとに、このように1ファイルにまとめると、プロンプトで「`api_spec.md` を参照して実装して」のように指示しやすい。
* **数式・ルールはあいまいさを減らす**: 可能な範囲で「〜とする」「〜のときは X とする」と明文化すると、AI の解釈ブレが減り、テストで仕様と実装の対応が取りやすい。
* **共通仕様は参照で済ませる**: 既存の COMMON_SPEC 等は「準拠する」とだけ書き、本文は別リポジトリに任せる。重複を避けつつ、プロジェクト固有の部分だけを spec に書く。
* **見出しタグで横断参照**: 各見出し末尾に `` `{@doc:slug}` `` を置く ([specs.md > 見出しタグ](./specs.md#specs-heading-tags) を参照)。

---

## 4. 本リポジトリ (S2J Source List) への適用 — 推奨構成 `{@spec-structure:s4}`

本リポジトリの `docs/` に **実在するファイル** だけを使い、要件・ドメインルール、CI を分割します。公開 API の利用例は [SPEC.md > 使用方法](./SPEC.md#6-使用方法) とリポジトリ直下の `README.md` に置き、別途 `api_spec.md` 等は用意しません。

### 4.1. 推奨ファイル構成 `{@spec-structure:s4-1}`

| ファイル | 役割 | 現状 `SPEC.md` との対応 (目安) |
| --- | --- | --- |
| [specs.md](./specs.md) | 仕様の起点。下表へのリンクとクイック参照。 | はじめにの「仕様の入口」 |
| [overview.md](./overview.md) | 存在理由・スコープ・共通 SPEC への参照。 | §1 (詳細は委譲) |
| [architecture.md](./architecture.md) | コード構造と責務 (Core/UI/Platform、ファイル配置)。 | §4 |
| [selection_spec.md](./selection_spec.md) | 選択・インライン編集ルール。 | §4.6.3、§6 (利用例の補足) |
| [search_spec.md](./search_spec.md) | 検索マッチング・親子表示ルール。 | 検索機能 (本文は本 spec に委譲) |
| [drag_drop_spec.md](./drag_drop_spec.md) | ドラッグ & ドロップ (未実装含む) の設計指針。 | §4.6.4 |
| [status.md](./status.md) | 実装状況の入口 (カテゴリー要約・短期 Backlog 索引)。 | §11・§12の要約 (詳細は SPEC に委譲) |
| [SPEC.md](./SPEC.md) | 要件概要、実装状況、Backlog、品質評価、Appendix。 | 本体 (ハブ) |
| [SPEC_CICD.md](./SPEC_CICD.md) | CI/CD、ローカルテスト、lint。 | §9、Appendix の CI 補足 |
| [SPEC_STRUCTURE.md](./SPEC_STRUCTURE.md) | 本ドキュメント。細分化の方針。 | (メタ) |

### 4.2. 改善の効果 `{@spec-structure:s4-2}`

* **AI 伴走**: 選択の挙動→ [selection_spec.md](./selection_spec.md)、検索の親子表示→ [search_spec.md](./search_spec.md)、D&D → [drag_drop_spec.md](./drag_drop_spec.md)、どこにコードを書くか→ [architecture.md](./architecture.md) と、タスクごとに spec を1つ指定しやすい。
* **メンテナンス**: ワークフロー・`test-local.sh`・`npm run lint:*` は [SPEC_CICD.md](./SPEC_CICD.md) に集約。プラットフォーム差は [architecture.md](./architecture.md) §5と [SPEC.md](./SPEC.md) §4.6を実装とそろえる。
* **オンボーディング**: [specs.md](./specs.md) から一覧し、必要な spec だけを開く。

### 4.3. 移行・更新の進め方 `{@spec-structure:s4-3}`

新規の `docs/*.md` 名は増やさず、既存ファイルの責務を守ります。

1. **[specs.md](./specs.md) を常に最新** にし、§4.1の一覧と [specs.md](./specs.md) の表を一致させる。
2. **ドメインルールの追加・変更** は、先に `selection_spec` / `search_spec` / `drag_drop_spec` のいずれかに明文化し、`SPEC.md` には要約とリンクのみ残す。
3. **ディレクトリ・ファイル責務の変更** は [architecture.md](./architecture.md) を更新し、[overview.md](./overview.md) (最小 OS 等) と矛盾がないか確認する。
4. **CI、ワークフロー、lint** は [SPEC_CICD.md](./SPEC_CICD.md) と `.github/workflows/` をセットで更新する (`SPEC.md` §9は概要リンクにとどめる)。
5. **[SPEC.md](./SPEC.md)** は実装状況、Backlog、Appendix の更新が集中するハブとし、先頭から [specs.md](./specs.md) に誘導する。

### 4.4. クイック参照 `{@spec-structure:s4-4}`

* **なぜこのプロジェクトがあるか** → [overview.md](./overview.md)
* **コードはどこに何を書くか** → [architecture.md](./architecture.md)
* **選択・編集の挙動** → [selection_spec.md](./selection_spec.md)
* **検索のマッチングルール** → [search_spec.md](./search_spec.md)
* **D&D の仕様** → [drag_drop_spec.md](./drag_drop_spec.md)
* **実装状況 (要約)** → [status.md](./status.md)
* **実装状況、Backlog (詳細)** → [SPEC.md](./SPEC.md)
* **CI やローカルテスト** → [SPEC_CICD.md](./SPEC_CICD.md)

---

## 6. まとめ `{@spec-structure:s6}`

* Swift アプリケーションでも、**「存在理由」「API 契約」「ドメインルール」「コード構造」「プラットフォーム差」「リソース定義」** などは、それぞれ1ファイルにまとめておくと、AI 伴走とメンテナンスの両方に有利です。
* **仕様の起点 (specs.md) を1つ用意** し、そこから各 spec にリンクする構成にすると、参照が安定します。
* 本リポジトリでは [§4](#4-本リポジトリ-s2j-source-list-への適用--推奨構成) のとおり、`docs/` 配下の実在ファイルだけで同様の分割を運用します。
