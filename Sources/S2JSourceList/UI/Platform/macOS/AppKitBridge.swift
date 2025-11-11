//
//  AppKitBridge.swift
//  S2JSourceList
//
//  Created by S2J Source List Generator
//

#if os(macOS)
import AppKit
import SwiftUI

/** 
 * macOS 固有の機能を提供するための、AppKit ブリッジ用のユーティリティクラス
 */
public struct AppKitBridge {
    /** 
     * AppKit から現在のアクセントカラーを取得します。
     * - Returns: アクセントカラー
     */
    public static var accentColor: Color {
        Color(NSColor.controlAccentColor)
    }

    /** 
     * ウィンドウ背景色を取得します。
     * - Returns: ウィンドウ背景色
     */
    public static var windowBackgroundColor: Color {
        Color(NSColor.windowBackgroundColor)
    }

    /** 
     * テキストカラーを取得します。
     * - Returns: テキストカラー
     */
    public static var textColor: Color {
        Color(NSColor.textColor)
    }

    /** 
     * セカンダリー・テキストカラーを取得します。
     * - Returns: セカンダリー・テキストカラー
     */
    public static var secondaryTextColor: Color {
        Color(NSColor.secondaryLabelColor)
    }
}
#endif
