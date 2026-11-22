# S2J Source List - UI / スナップショットテスト仕様

## 1. 目的 `{@ui-test:s1}`

主要操作と SwiftUI レンダリングを CI で検証する方針を定義します。

## 2. 現状 `{@ui-test:s2}`

| 種別 | 実装 | 実行環境 |
| --- | --- | --- |
| 統合 UI フロー | `SourceListUserFlowTests` — 選択・展開・リネーム・移動 | macOS (`swift test`)、iPadOS (`xcodebuild test`) |
| スナップショット | `SourceListSnapshotTests` + [pointfreeco/swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing) | macOS は `NSHostingController` → `.image`、参照画像は `Tests/S2JSourceListTests/__Snapshots__/` |
| カバレッジ70% | `scripts/check-coverage.sh` — `Sources/S2JSourceList` 行カバレッジ | ローカル / CI (`MIN_COVERAGE=70`) |

## 3. 実装マッピング `{@ui-test:s3-impl}`

| モジュール | テスト |
| --- | --- |
| `SourceListService` / `SelectionManager` / `SourceItem` | 既存 `*Tests.swift` |
| `SourceListOutline.filterItems` | `SourceListOutlineTests` ([search_spec.md](./search_spec.md)) |
| `SourceListKeyboardNavigation` | `SourceListKeyboardNavigationTests` ([accessibility_spec.md](./accessibility_spec.md)) |
| `SourceListDragDrop` | `SourceListDragDropTests` ([drag_drop_spec.md](./drag_drop_spec.md)) |
| `IconProvider` / `AppKitBridge` (macOS) | `IconProviderTests` / `AppKitBridgeTests` |

## 4. 対象操作 (UI フロー) `{@ui-test:s3}`

`SourceListUserFlowTests` がカバーする操作:

* 行選択 (`SelectionManager`)
* グループ展開 (`expandItem`)
* インラインリネーム相当 (`renameItem`)
* ツリー内移動 (`moveItem`)

## 5. スナップショット `{@ui-test:s4}`

* `SourceRowView` — 通常行・選択行・編集中・カスタム行
* `SidebarView` — 検索バー付きサンプル階層、D&D 有効

記録更新: `SNAPSHOT_TESTING_RECORD=1 swift test --filter SourceListSnapshotTests`

**macOS 注意**: swift-snapshot-testing の SwiftUI `.image` は iOS 向けのため、macOS では `NSHostingController` を `Snapshotting<NSViewController, NSImage>.image` で比較する。

## 6. 関連 `{@ui-test:s5}`

* 検索フィルター: [search_spec.md](./search_spec.md)
* Xcode Preview (Canvas): [devx_spec.md](./devx_spec.md) — CI スナップショットとは別経路
* ドメイン spec 索引: [specs.md](./specs.md)
* CI: [SPEC_CICD.md](./SPEC_CICD.md)
* 実装状況: [status.md](./status.md) §テスト拡張