# S2J Source List

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-3.0.en.html)
[![Xcode](https://img.shields.io/badge/Xcode-26.5-blue?logo=xcode&logoColor=white)](https://developer.apple.com/xcode/)
[![Swift](https://img.shields.io/badge/Swift-6.3-blue?logo=Swift&logoColor=white)](https://www.swift.org)
[![macOS](https://img.shields.io/badge/macOS-14.6+-blue?logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![iPadOS](https://img.shields.io/badge/iPadOS-17.6+-blue?logo=apple&logoColor=white)](https://www.apple.com/ipados/)

## Description

<!-- 
S2J Source List is a SwiftUI-based hierarchical sidebar component for macOS and iPadOS. This library has been ported from the popular PXSourceList project, bringing its functionality to the SwiftUI ecosystem. It provides a modern, declarative API for displaying tree-structured data with support for such as selection, editing, icons, badges, and more.
 -->

S2J Source List は、macOS および iPadOS 向けの SwiftUI ベースの階層型サイドバーコンポーネントです。本ライブラリは、人気の [PXSourceList](https://github.com/alexrozanski/PXSourceList) プロジェクトから移植され、その機能を SwiftUI エコシステムにもたらします。ツリー構造のデータを表示するためのモダンな宣言型 API を提供し、選択、編集、アイコン、バッジなどの機能をサポートします。

## Features

<!-- 
* ✅ Hierarchical view with expand/collapse (`DisclosureGroup` + `SourceListService` expansion state)
* ✅ Single selection / Multiple selection (`SelectionManager` + `SidebarView.allowsMultipleSelection`)
* ✅ Icon and badge display (`IconProvider`; AppKit fallback on macOS)
* ✅ Inline editing (`InlineEditorView` / `renameItem`)
* ✅ Context menu (default + `contextMenuBuilder`)
* ✅ Search filter (`showsSearchBar` + `SourceListOutline.filterItems`) — [search_spec.md](docs/search_spec.md)
* ✅ Custom rows (`customRowContent`)
* ✅ Drag-and-drop within the tree (`allowsDragAndDrop` + `moveItem` / `itemsMoved`) — [drag_drop_spec.md](docs/drag_drop_spec.md)
* ✅ Keyboard navigation support (`SourceListKeyboardNavigation`) — [accessibility_spec.md](docs/accessibility_spec.md)
* ✅ Accessibility identifiers for VoiceOver and Dynamic Type — [accessibility_spec.md](docs/accessibility_spec.md)
* ✅ Platform-specific list styles (macOS `.sidebar`, iPadOS `.insetGrouped`)
* ✅ Dark Mode and Light Mode
* ✅ Localization (`en` / `ja` / `Base`)
* ✅ Xcode Preview (`S2JSourceListPreviews`) and `SampleApp` for macOS (`project.yml` / XcodeGen)
 -->

* ✅ 展開/折り畳み付き階層表示 (`DisclosureGroup` + `SourceListService` の展開状態)
* ✅ 単一選択 / 複数選択 (`SelectionManager` + `SidebarView.allowsMultipleSelection`)
* ✅ アイコン・バッジ表示 (`IconProvider`、macOS は AppKit フォールバック)
* ✅ インライン編集 (`InlineEditorView` / `renameItem`)
* ✅ コンテキストメニュー (デフォルト + `contextMenuBuilder`)
* ✅ 検索フィルター (`showsSearchBar` + `SourceListOutline.filterItems`) — [search_spec.md](docs/search_spec.md)
* ✅ カスタム行 (`customRowContent`)
* ✅ ツリー内ドラッグ & ドロップ (`allowsDragAndDrop` + `moveItem` / `itemsMoved`) — [drag_drop_spec.md](docs/drag_drop_spec.md)
* ✅ キーボードナビゲーション補助 (`SourceListKeyboardNavigation`) — [accessibility_spec.md](docs/accessibility_spec.md)
* ✅ VoiceOver / Dynamic Type 向けアクセシビリティ識別子 — [accessibility_spec.md](docs/accessibility_spec.md)
* ✅ プラットフォーム別リストスタイル (macOS `.sidebar`、iPadOS `.insetGrouped`)
* ✅ ダークモード・ライトモード
* ✅ ローカライズ (`en` / `ja` / `Base`)
* ✅ Xcode Preview (`S2JSourceListPreviews`) と macOS 用 `SampleApp` (`project.yml` / XcodeGen)

## License

<!-- 
This project is licensed under the GPL v3.0 or later. For details, please refer to the [LICENSE](LICENSE) file.
 -->

本プロジェクトは GPL3.0以降ライセンスの下で提供されています。詳細は [LICENSE](LICENSE) ファイルを参照してください。

## Support and Contact

<!-- 
For support, feature requests, or bug reports, please visit the [GitHub Issues](https://github.com/stein2nd/s2j-source-list/issues) page.
 -->

サポート、機能リクエスト、またはバグ報告については、[GitHub Issues](https://github.com/stein2nd/s2j-source-list/issues) ページをご覧ください。

## Installation

### Requirements

* macOS v14.6+ / iPadOS v17.6+
* Xcode v26.5+
* Swift v6.3+

### Swift Package Manager

<!-- 
Add the following to your `Package.swift` file.
 -->

`Package.swift` ファイルに以下を追加します。

```swift
dependencies: [
    .package(url: "https://github.com/stein2nd/s2j-source-list.git", from: "2.0.26")
]
```

<!-- 
Or add it through Xcode:
 -->

あるいは Xcode から追加します。

<!-- 
1. File → Add Package Dependency
2. Enter the repository URL: `https://github.com/stein2nd/s2j-source-list.git`
3. Select a version and add it to the target
 -->

1. ファイル → パッケージ依存関係を追加
2. リポジトリ URL を入力: `https://github.com/stein2nd/s2j-source-list.git`
3. バージョンを選択し、ターゲットに追加

## Usage

### Basic Example

```swift
import SwiftUI
import S2JSourceList

struct ContentView: View {
    @StateObject private var service = SourceListService()
    @StateObject private var selectionManager = SelectionManager()
    
    var body: some View {
        SidebarView(
            service: service,
            selectionManager: selectionManager
        )
        .onAppear {
            // Setup initial data
            service.rootItems = [
                .group(
                    title: "Favorites",
                    children: [
                        .item(title: "Item 1", icon: "star.fill"),
                        .item(title: "Item 2", icon: "star.fill")
                    ]
                ),
                .item(title: "Document", icon: "doc.fill")
            ]
        }
    }
}
```

### Advanced Example

```swift
// Ensure that `allowsMultipleSelection` and `SelectionManager.selectionMode` match (SidebarView does not overwrite the mode)
@StateObject private var selectionManager = SelectionManager(selectionMode: .multiple)

SidebarView(
    service: service,
    selectionManager: selectionManager,
    allowsMultipleSelection: true,
    allowsDragAndDrop: true,
    showsSearchBar: true,
    indentationWidth: 20,
    iconSize: 16,
    customRowContent: { item in
        AnyView(
            HStack {
                Text(item.title)
                Spacer()
                if let badge = item.badge {
                    Text(badge)
                        .font(.caption)
                }
            }
        )
    },
    contextMenuBuilder: { item in
        [
            SidebarView.ContextMenuAction(
                title: "Rename",
                action: { /* Handle rename */ }
            ),
            SidebarView.ContextMenuAction(
                title: "Delete",
                action: { /* Handle delete */ },
                isDestructive: true
            )
        ]
    }
)
```

## API Reference

### SourceItem

<!-- 
Represents an item within the source list hierarchy.
 -->

source list 階層内の項目を表します。

```swift
let item = SourceItem(
    title: "My Item",
    icon: "folder",
    badge: "5",
    children: [/* child items */],
    isEditable: true,
    isSelectable: true
)
```

### SourceListService

<!-- 
It manages the data model and provides operations for working with items.
 -->

データモデルを管理し、アイテムを操作するための操作を提供します。

```swift
let service = SourceListService()
service.rootItems = [/* items */]
service.renameItem(id: itemId, newTitle: "New Title")
service.deleteItem(id: itemId)
service.toggleExpansion(id: groupId)

// Drag-and-drop completion (or programmatic sorting)
service.moveItem(id: itemId, to: .afterSibling(siblingId: otherId))
service.itemsMoved
    .sink { event in
        // event.itemId, event.newParentId, event.newIndex
    }
```

<!-- 
For more details, see [drag_drop_spec.md](docs/drag_drop_spec.md).
 -->

詳細は [drag_drop_spec.md](docs/drag_drop_spec.md) を参照してください。

### SelectionManager

<!-- 
Manages the selection state.
 -->

選択状態を管理します。

```swift
let selectionManager = SelectionManager(selectionMode: .single)
selectionManager.selectItem(itemId)
selectionManager.toggleSelection(itemId) // When multiple selections are made
selectionManager.isSelected(itemId)
selectionManager.clearSelection()
```

<!-- 
When using `allowsMultipleSelection`, we recommend using `SelectionManager(selectionMode: .multiple)`. For more details, see [selection_spec.md](docs/selection_spec.md).
 -->

`allowsMultipleSelection` を使う場合は `SelectionManager(selectionMode: .multiple)` を推奨します。詳細は [selection_spec.md](docs/selection_spec.md) を参照してください。

## Contributing

<!-- 
We welcome your contributions. Please follow these steps:
 -->

貢献をお待ちしています。以下の手順に従ってください。

<!-- 
1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/amazing-feature`).
3. Commit your changes (`git commit -m ‘Add some amazing feature’`).
4. Push to the feature branch (`git push origin feature/amazing-feature`).
5. Open a Pull Request.
 -->

1. リポジトリをフォークしてください。
2. 機能ブランチを作成してください (`git checkout -b feature/amazing-feature`)。
3. 変更をコミットしてください (`git commit -m 'Add some amazing feature'`)。
4. 機能ブランチにプッシュしてください (`git push origin feature/amazing-feature`)。
5. Pull Request を開いてください。

<!-- 
*For detailed information, please refer to the [SPEC.md](SPEC.md) file.*
 -->

*詳細な情報については、[SPEC.md](SPEC.md) ファイルを参照してください。*

### Development Guidelines

<!-- 
* Please follow the existing coding style (`npm run lint:swift` / `npm run format:swift`).
* For new features, add Swift types and tests, and update the corresponding spec in `docs/`.
* You can check the formatting of Markdown files using `npm run lint:docs`.
 -->

* 既存のコードスタイルに従ってください (`npm run lint:swift` / `npm run format:swift`)。
* 新機能には Swift 型とテストを追加し、`docs/` の該当 spec を更新してください。
* Markdown は `npm run lint:docs` で表記を確認できます。

### Running Tests Locally

<!-- 
To run a workflow similar to the [GitHub Actions “Swift Test”](.github/workflows/swift-test.yml) locally before committing, use `scripts/test-local.sh` ([SPEC_CICD.md](docs/SPEC_CICD.md)).
 -->

[GitHub Actions「Swift Test」](.github/workflows/swift-test.yml) に近い流れを、コミット前にローカルで回すには `scripts/test-local.sh` を使います ([SPEC_CICD.md](docs/SPEC_CICD.md))。

```zsh
# Recommended Entries (If `project.yml` exists, XcodeGen and iOS tests will also be attempted)
npm run test:local

# Configure the Xcode project for the iPad simulator (similar to “test-ios” in CI)
npm run test:local:iOSfull

# Omit iOS and include only macOS
npm run test:local -- --skip-ios
```

<!-- 
**Priority**: 1. Command-line arguments (`npm run test:local -- …`) > 2. Automatic detection from `Package.swift` / `project.yml` > 3. Environment variables > 4. Default values
 -->

**優先順位**: 1. コマンドライン引数 (`npm run test:local -- …`) > 2. `Package.swift` / `project.yml` からの自動検出 > 3. 環境変数 > 4. デフォルト値

<!-- 
| Stage | Details |
| --- | --- |
| macOS (SPM) | `swift test --enable-code-coverage` (explicitly specify the macOS SDK) |
| macOS (XcodeGen) | If `project.yml` exists, run `xcodegen generate`, then run `xcodebuild test` with `S2JSourceList-macOS` |
| iPadOS | Run `xcodebuild` with `S2JSourceList-iOS` (simulator; default device is iPad Pro / iOS **17.6**) |
 -->

| 段階 | 内容 |
| --- | --- |
| macOS (SPM) | `swift test --enable-code-coverage` (macOS SDK を明示) |
| macOS (XcodeGen) | `project.yml` があるとき `xcodegen generate` のうえ `S2JSourceList-macOS` で `xcodebuild test` |
| iPadOS | `S2JSourceList-iOS` で `xcodebuild` (シミュレーター、デフォルト端末は iPad Pro / iOS **17.6**) |

<!-- 
In repositories that contain `project.yml`, Xcode project generation is enabled by default. If `xcodegen` is not installed, run `brew install xcodegen` or specify `--xcodegen-auto-install`.
 -->

`project.yml` があるリポジトリでは、追加オプションなしで Xcode プロジェクト生成が有効になります。`xcodegen` がない場合は `brew install xcodegen` か `--xcodegen-auto-install` を指定してください。

<!-- 
**Test Types** ([ui_test_spec.md](docs/ui_test_spec.md)):
 -->

**テストの種類** ([ui_test_spec.md](docs/ui_test_spec.md)):

<!-- 
* **Unit Tests** — Models, services, drag-and-drop, search, keyboard, etc.
* **UI Flows** — `SourceListUserFlowTests` (selection, expansion, renaming, moving)
* **Snapshots** — `SourceListSnapshotTests` are **GitHub Actions `macos-26` only** image comparisons. Use `XCTSkip` when running locally with `swift test` or on iOS (see the original PNG in the workflow’s **Record UI Snapshots** section)
 -->

* **ユニットテスト** — モデル・サービス・ドラッグ & ドロップ / 検索 / キーボード等
* **UI フロー** — `SourceListUserFlowTests` (選択・展開・リネーム・移動)
* **スナップショット** — `SourceListSnapshotTests` は **GitHub Actions `macos-26` のみ**画像比較。ローカル `swift test` と iOS 実行時は XCTSkip (参照 PNG 正本は workflow **Record UI Snapshots**)

<!-- 
Line coverage for `Sources/S2JSourceList` **70%** gate (lcov aggregation; same `scripts/check-coverage.sh` as CI):
 -->

`Sources/S2JSourceList` の行カバレッジ **70%** ゲート (lcov 集計。CI と同じ `scripts/check-coverage.sh`):

```zsh
npm run test:coverage
```

<!-- 
Quality Check (Guidelines Before Committing):
 -->

品質チェック (コミット前の目安):

```zsh
npm run lint:swift   # SwiftLint + SwiftFormat + Periphery (xcodegen 含む)
npm run lint:docs    # README / CHANGELOG / docs
```

<!-- 
DocC API Reference (HTML):
 -->

DocC API リファレンス (HTML):

```zsh
npm run docs:docc
```

<!-- 
Output: `.build/docs/S2JSourceList/index.html` — [devx_spec.md](docs/devx_spec.md)
 -->

出力: `.build/docs/S2JSourceList/index.html` — [devx_spec.md](docs/devx_spec.md)

<!-- 
**Requirements**: macOS tests require the Swift v6.3+ toolchain. iPadOS tests and some `lint:swift` features require **Xcode v26.5+**.
 -->

**要件**: macOS テストは Swift v6.3+ toolchain。iPadOS テストと `lint:swift` の一部には **Xcode v26.5+** が必要です。

## Contributors & Developers

<!-- 
**“S2J Source List”** is open-source software. The following individuals have contributed to this plugin:
 -->

**"S2J Source List"** はオープンソース・ソフトウェアです。以下の皆様がこのツールに貢献しています。

<!-- 
* **Developer**: Koutarou ISHIKAWA
 -->

* **開発者**: Koutarou ISHIKAWA

## Acknowledgments

<!-- 
* Based on [PXSourceList](https://github.com/alexrozanski/PXSourceList) by Alex Rozanski
* Built with SwiftUI and Swift Package Manager
 -->

* Alex Rozanski 制作 [PXSourceList](https://github.com/alexrozanski/PXSourceList) をもとに作成
* SwiftUI および Swift Package Manager で構築
