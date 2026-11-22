# S2J Source List - アクセシビリティ仕様

## 1. 目的 `{@accessibility:s1}`

階層ソースリストにおける VoiceOver、キーボード、Dynamic Type の挙動を定義します。

## 2. 現状 `{@accessibility:s2}`

* `SourceRowView` — `accessibilityLabel` / `accessibilityValue` / `accessibilityHint` / `accessibilityIdentifier`、選択トレイト。
* グループ行はラベルにローカライズ済み「グループ」を付与。
* `SidebarView` — リストにフォーカスし、矢印キーで選択移動 (上下) と展開/折りたたみ (左右)。移動ロジックは `SourceListKeyboardNavigation`、表示順は `SourceListOutline`。
* Dynamic Type — タイトル・検索・インライン編集は `.font(.body)`、バッジは `.caption`。アイコン寸法とインデントは `@ScaledMetric(relativeTo: .body)`。
* 検索フィールドに `SourceList.Accessibility.Search.Label` を付与。

## 3. キーボード `{@accessibility:s3}`

| キー | 動作 |
| --- | --- |
| ↑ / ↓ | 表示中アウトライン上の **選択可能** 行を前後へ移動 (`SelectionManager.selectItem`) |
| ← / → | フォーカス行がグループのとき折りたたみ / 展開 (`toggleExpansion`) |

* インライン編集中はキーハンドラを無視する。
* 表示順は `SourceListOutline.visibleItems` (展開状態と `filterItems` 後のルートを反映)。
* 単体検証: `SourceListKeyboardNavigationTests` / `SourceListOutlineTests` ([ui_test_spec.md](./ui_test_spec.md))。

## 4. Dynamic Type `{@accessibility:s4}`

* テキストは SwiftUI のテキストスタイル (`.body` / `.caption`) を用い、システムの文字サイズに追従する。
* 行のインデント幅・デフォルトアイコンサイズは `SidebarView` 引数を `@ScaledMetric` でスケールする。
* `customRowContent` 内のフォントはホスト責任。

## 5. 未対応・将来 `{@accessibility:s5}`

* フルキーボードショートカット表 (Return でアクション等) の標準化。
* `accessibilityRotor` によるカテゴリージャンプ。
* VoiceOver のカスタムアクション (コンテキストメニュー項目の直接公開)。

## 6. 関連ドキュメント `{@accessibility:s6}`

* 実装状況: [status.md](./status.md) §アクセシビリティ
* Preview での目視確認: [devx_spec.md](./devx_spec.md)
* 要件要約: [SPEC.md §4.10](./SPEC.md#spec-s4-10)
* コード構成: [architecture.md](./architecture.md)