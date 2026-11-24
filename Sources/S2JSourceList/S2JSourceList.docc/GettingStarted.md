# Getting Started

S2J Source List をホストプロジェクトに組み込む手順の要約です。

## Add the package

`Package.swift` の依存に追加します。

```swift
.package(url: "https://github.com/stein2nd/s2j-source-list.git", from: "2.0.24")
```

ターゲット依存:

```swift
.product(name: "S2JSourceList", package: "s2j-source-list")
```

## Build a tree

``SourceItem`` で階層を定義し、``SourceListService`` に渡します。グループは ``SourceItem/group(title:icon:children:isExpanded:)``、葉は ``SourceItem/item(title:icon:badge:)`` が便利です。

## Selection

``SelectionManager`` を ``SidebarView`` と同じ選択モードで生成します。`allowsMultipleSelection` を `true` にする場合は `SelectionManager(selectionMode: .multiple)` を推奨します。

## Optional features

| フラグ / API | 説明 |
| --- | --- |
| `showsSearchBar` | タイトル部分一致フィルター |
| `allowsDragAndDrop` | ツリー内 `moveItem` |
| `allowsMultipleSelection` | 行タップでトグル選択 |
| `contextMenuBuilder` | 行ごとのコンテキストメニュー |

## Xcode Previews

`Sources/S2JSourceList/Preview Content/` のサンプルと `#Preview` を Xcode で開いて再利用できます。詳細は [devx_spec.md](https://github.com/stein2nd/s2j-source-list/blob/main/docs/devx_spec.md)。