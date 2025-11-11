//
//  IconProvider.swift
//  S2JSourceList
//
//  Created by S2J Source List Generator
//

import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/** 
 * Sourcelist アイテム向けのアイコン提供ユーティリティクラス
 */
public struct IconProvider {
    /**
     * 指定されたアイコン名の画像を取得します。
     * - Parameter iconName: アイコン名 (システム名またはアセット名)
     * - Returns: Image ビュー、アイコン名が無効な場合は nil を返します。
     */
    public static func image(for iconName: String?) -> Image? {
        guard let iconName = iconName, !iconName.isEmpty else { return nil }
        
        // Try system image first
        #if canImport(UIKit)
        if UIImage(systemName: iconName) != nil {
            return Image(systemName: iconName)
        }
        
        // Try asset image
        if UIImage(named: iconName) != nil {
            return Image(iconName)
        }
        #elseif canImport(AppKit)
        if NSImage(systemSymbolName: iconName, accessibilityDescription: nil) != nil {
            return Image(systemName: iconName)
        }
        
        // Try asset image
        if NSImage(named: iconName) != nil {
            return Image(iconName)
        }
        #endif
        
        return nil
    }

    /** 
     * 指定されたアイコン名が無効な場合は、デフォルトのアイコンを使用します。
     * - Parameter iconName: アイコン名
     * - Parameter defaultIcon: デフォルトのアイコン名
     * - Returns: Image ビュー
     */
    public static func image(for iconName: String?, defaultIcon: String = "folder") -> Image {
        if let image = image(for: iconName) {
            return image
        }
        return Image(systemName: defaultIcon)
    }
}

#if canImport(AppKit)
extension IconProvider {
    /**
     * 必要に応じて AppKit ブリッジ用に、macOS 向けの NSImage を取得します。
     * - Parameter iconName: アイコン名
     * - Returns: NSImage、アイコン名が無効な場合は nil を返します。
     */
    public static func nsImage(for iconName: String?) -> NSImage? {
        guard let iconName = iconName, !iconName.isEmpty else { return nil }
        
        if let image = NSImage(systemSymbolName: iconName, accessibilityDescription: nil) {
            return image
        }
        
        return NSImage(named: iconName)
    }
}
#endif
