# S2J Source List - UI / スナップショットテスト仕様

## 1. 目的 `{@ui-test:s1}`

主要操作と SwiftUI レンダリングを CI で検証する方針を定義します。

## 2. 現状 `{@ui-test:s2}`

| 種別 | 実装 | 実行環境 |
| --- | --- | --- |
| 統合 UI フロー | `SourceListUserFlowTests` — 選択・展開・リネーム・移動 | macOS (`swift test`)、iPadOS (`xcodebuild test`) |
| スナップショット | `SourceListSnapshotTests` + [pointfreeco/swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing) | **GITHUB_ACTIONS** 上のみ実行。参照 PNG は `macos-26` 正本、`__Snapshots__/` |
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

記録更新:

* 正本ランナー: GitHub Actions `macos-26`（ワークフロー **Record UI Snapshots** / `SNAPSHOT_TESTING_RECORD=all`）
* ローカル: `swift test` では `SourceListSnapshotTests` をスキップ（参照 PNG と描画が一致しないため）。再記録後に CI で比較する

**macOS 注意**: swift-snapshot-testing の SwiftUI `.image` は iOS 向けのため、macOS では `NSHostingController` を `Snapshotting<NSViewController, NSImage>.image` で比較する。

**CI 安定化**: ホスティングで `en_US`・ライト・アクア外観を固定。`precision` 0.98 / `perceptualPrecision` 0.97。参照 PNG は `Package.swift` の `testTarget` で `exclude: ["__Snapshots__"]`。

## 6. 関連 `{@ui-test:s5}`

* 検索フィルター: [search_spec.md](./search_spec.md)
* Xcode Preview (Canvas): [devx_spec.md](./devx_spec.md) — CI スナップショットとは別経路
* ドメイン spec 索引: [specs.md](./specs.md)
* CI: [SPEC_CICD.md](./SPEC_CICD.md)
* 実装状況: [status.md](./status.md) §テスト拡張