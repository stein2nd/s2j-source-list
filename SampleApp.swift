import S2JSourceList
import SwiftUI

@main
struct SampleApp: App {
    @StateObject private var service = SourceListService(
        rootItems: [
            SourceItem(title: "Library", icon: "folder", children: [
                SourceItem(title: "Documents", icon: "doc"),
                SourceItem(title: "Downloads", icon: "arrow.down.circle")
            ]),
            SourceItem(title: "Tags", icon: "tag")
        ]
    )
    @StateObject private var selectionManager = SelectionManager(selectionMode: .multiple)

    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                SidebarView(
                    service: service,
                    selectionManager: selectionManager,
                    allowsMultipleSelection: true,
                    showsSearchBar: true
                )
                .frame(minWidth: 220)
            } detail: {
                Text("Select an item in the source list")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
