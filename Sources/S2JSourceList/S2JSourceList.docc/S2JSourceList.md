# ``S2JSourceList``

SwiftUI で階層型ソースリスト (サイドバー) を構築するライブラリです。

## Overview

`SidebarView` を中心に、項目モデル ``SourceItem``、データ供給 ``SourceListService``、選択 ``SelectionManager`` を組み合わせて macOS / iPadOS 向けのリスト UI を実装します。検索フィルター、インラインリネーム、ドラッグ & ドロップ、VoiceOver / キーボードナビゲーションをサポートします。

ホストアプリでは Swift Package として依存を追加し、`SourceListService` と `SelectionManager` を用意して ``SidebarView`` に渡します。

```swift
import S2JSourceList
import SwiftUI

struct ContentView: View {
    @StateObject private var service = SourceListService(rootItems: [...])
    @StateObject private var selection = SelectionManager()

    var body: some View {
        SidebarView(
            service: service,
            selectionManager: selection,
            showsSearchBar: true
        )
    }
}
```

マークダウン仕様・CI はリポジトリの `docs/` (入口: [specs.md](https://github.com/stein2nd/s2j-source-list/blob/main/docs/specs.md)) を参照してください。

## Topics

### Essentials

- ``SidebarView``
- ``SourceItem``
- ``SourceListService``
- ``SelectionManager``

### Views

- ``SourceRowView``
- ``InlineEditorView``

### Platform

- ``AppKitBridge``
- ``iPadOptimizations``

### Services and utilities

- ``IconProvider``
- <doc:GettingStarted>

## See Also

- [README](https://github.com/stein2nd/s2j-source-list#readme)
- [devx_spec.md — Preview / DocC](https://github.com/stein2nd/s2j-source-list/blob/main/docs/devx_spec.md)