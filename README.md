# s2j-source-list

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-3.0.en.html)
[![React](https://img.shields.io/badge/Swift-5.9-blue?logo=Swift&logoColor=white)](https://www.swift.org)

## Description

<!-- 
S2J Source List is a SwiftUI-based hierarchical sidebar component for macOS and iPadOS. It provides a modern, declarative API for displaying tree-structured data with support for selection, editing, icons, badges, and more.
 -->

S2J Source List は、macOS および iPadOS 向けの SwiftUI ベースの階層型サイドバーコンポーネントです。選択、編集、アイコン、バッジなどの機能をサポートし、ツリー構造のデータを表示するためのモダンで宣言的な API を提供します。

## Features

<!-- 
* ✅ Hierarchical display with expand/collapse
* ✅ Single and multiple selection modes
* ✅ Icon and badge display
* ✅ Inline editing (rename)
* ✅ Context menu support
* ✅ Search functionality
* ✅ Custom row content
* ✅ Dark mode support
* ✅ Localization (English, Japanese)
 -->

* ✅ 展開/折り畳み機能付き階層表示
* ✅ 単一選択モードと複数選択モード
* ✅ アイコンとバッジ表示
* ✅ インライン編集 (名称変更)
* ✅ コンテキストメニュー対応
* ✅ 検索機能
* ✅ カスタム行コンテンツ
* ✅ ダークモード対応
* ✅ ローカライズ (英語、日本語)

## License

<!-- 
This project is licensed under the GPL 3.0+ License. See the [LICENSE](LICENSE) file for details.
 -->

本プロジェクトは GPL3.0以降ライセンスの下で提供されています。詳細は [LICENSE](LICENSE) ファイルを参照してください。

## Support and Contact

<!-- 
For support, feature requests, or bug reports, please visit the [GitHub Issues](https://github.com/stein2nd/s2j-source-list/issues) page.
 -->

サポート、機能リクエスト、またはバグ報告については、[GitHub Issues](https://github.com/stein2nd/s2j-source-list/issues) ページをご覧ください。

## Installation

### Requirements

* macOS v12.0+ / iPadOS v15.0+
* Swift v5.8+
* Xcode v14.0+

<!-- 
### Swift Package Manager
 -->

### Swift Package Manager

<!-- 
Add the following to your `Package.swift` file.
 -->

`Package.swift` ファイルに以下を追加します。

```swift
dependencies: [
    .package(url: "https://github.com/stein2nd/s2j-source-list.git", from: "0.1.0")
]
```

<!-- 
Or add it through Xcode:
 -->

あるいは Xcode から追加します。

<!-- 
1. File → Add Package Dependencies
2. Enter the repository URL: `https://github.com/stein2nd/s2j-source-list.git`
3. Choose the version and add to your target
 -->

1. ファイル → パッケージ依存関係を追加
2. リポジトリ URL を入力: `https://github.com/stein2nd/s2j-source-list.git`
3. バージョンを選択し、ターゲットに追加

## Usage

<!-- 
### Basic Example
 -->

### 基本的な例

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

<!-- 
### Advanced Example
 -->

### 高度な例

```swift
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
Represents an item in the source list hierarchy.
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
Manages the data model and provides operations for manipulating items.
 -->

データモデルを管理し、アイテムを操作するための操作を提供します。

```swift
let service = SourceListService()
service.rootItems = [/* items */]
service.renameItem(id: itemId, newTitle: "New Title")
service.deleteItem(id: itemId)
service.toggleExpansion(id: groupId)
```

### SelectionManager

<!-- 
Manages selection state.
 -->

選択状態を管理します。

```swift
let selectionManager = SelectionManager(selectionMode: .single)
selectionManager.selectItem(itemId)
selectionManager.isSelected(itemId)
selectionManager.clearSelection()
```

## Credits

Based on [PXSourceList](https://github.com/alexrozanski/PXSourceList) by Alex Rozanski.
