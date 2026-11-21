//
//  SourceListDragDrop.swift
//  S2JSourceList
//

import Foundation

enum SourceListDragDrop {
    static let prefix = "s2j-source-item:"

    static func payload(for id: UUID) -> String {
        prefix + id.uuidString
    }

    static func parse(_ string: String) -> UUID? {
        guard string.hasPrefix(prefix) else { return nil }
        let raw = String(string.dropFirst(prefix.count))
        return UUID(uuidString: raw)
    }
}
