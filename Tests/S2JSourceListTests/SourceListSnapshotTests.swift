//
//  SourceListSnapshotTests.swift
//  S2JSourceListTests
//

import SnapshotTesting
import SwiftUI
@testable import S2JSourceList
import XCTest

#if os(macOS)
import AppKit
#endif

final class SourceListSnapshotTests: XCTestCase {
    @MainActor
    func testSourceRowViewDefault() {
        let item = SourceItem(title: "Documents", icon: "doc.fill", badge: "3")
        let view = sourceRowView(item: item, isSelected: false)
        assertViewSnapshot(of: view, size: CGSize(width: 296, height: 56))
    }

    @MainActor
    func testSourceRowViewSelected() {
        let item = SourceItem(title: "Selected", icon: "star.fill")
        let view = sourceRowView(item: item, isSelected: true)
        assertViewSnapshot(of: view, size: CGSize(width: 296, height: 56))
    }

    @MainActor
    func testSidebarViewWithSampleData() {
        let view = sampleSidebarView()
        assertViewSnapshot(of: view, size: CGSize(width: 320, height: 420))
    }

    @MainActor
    func testSidebarViewDragDropEnabled() {
        let view = sampleSidebarView(allowsDragAndDrop: true)
        assertViewSnapshot(of: view, size: CGSize(width: 320, height: 420))
    }

    @MainActor
    func testSourceRowViewEditing() {
        let item = SourceItem(title: "Editing", icon: "pencil", isEditable: true)
        let view = SourceRowView(
            item: item,
            isSelected: true,
            isEditing: true,
            onSelect: {},
            onEdit: { _ in },
            onCancelEdit: {}
        )
        .frame(width: 280)
        .padding(8)
        assertViewSnapshot(of: view, size: CGSize(width: 296, height: 56))
    }

    @MainActor
    func testSourceRowViewIndentedWithCustomContent() {
        let item = SourceItem.group(title: "Group", icon: "folder", children: [])
        let view = SourceRowView(
            item: item,
            isSelected: false,
            indentationLevel: 2,
            onSelect: {},
            onEdit: { _ in },
            onCancelEdit: {},
            customContent: { row in AnyView(Text("Custom \(row.title)").font(.caption)) }
        )
        .frame(width: 280)
        .padding(8)
        assertViewSnapshot(of: view, size: CGSize(width: 296, height: 56))
    }

    @MainActor
    private func sourceRowView(item: SourceItem, isSelected: Bool) -> some View {
        SourceRowView(
            item: item,
            isSelected: isSelected,
            onSelect: {},
            onEdit: { _ in },
            onCancelEdit: {}
        )
        .frame(width: 280)
        .padding(8)
    }

    @MainActor
    private func sampleSidebarView(allowsDragAndDrop: Bool = false) -> some View {
        let service = SourceListService(
            rootItems: [
                .group(
                    title: "Favorites",
                    icon: "star.fill",
                    children: [.item(title: "Item A", icon: "doc")],
                    isExpanded: true
                ),
                .item(title: "Inbox", icon: "tray", badge: "2")
            ]
        )
        let selection = SelectionManager()
        return SidebarView(
            service: service,
            selectionManager: selection,
            allowsDragAndDrop: allowsDragAndDrop,
            showsSearchBar: true
        )
    }
}

@MainActor
private func assertViewSnapshot<V: View>(
    of view: V,
    size: CGSize,
    filePath: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line
) {
    #if os(macOS)
    let controller = NSHostingController(rootView: view)
    controller.view.frame = CGRect(origin: .zero, size: size)
    SnapshotTesting.assertSnapshot(of: controller, as: .image(size: size), file: filePath, testName: testName, line: line)
    #elseif os(iOS)
    SnapshotTesting.assertSnapshot(
        of: view,
        as: .image(layout: .fixed(width: size.width, height: size.height)),
        file: filePath,
        testName: testName,
        line: line
    )
    #else
    XCTFail("Snapshot tests require macOS or iOS", file: filePath, line: line)
    #endif
}