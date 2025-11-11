//
//  iPadOptimizations.swift
//  S2JSourceList
//
//  Created by S2J Source List Generator
//

#if os(iOS)
import SwiftUI

/** 
 * iPadOS 固有の最適化とユーティリティクラス
 */
public struct iPadOptimizations {

    /** 
     * デフォルトの行高を取得します。
     * - Returns: デフォルトの行高
     */
    public static let defaultRowHeight: CGFloat = 44

    /** 
     * デフォルトのインデント幅を取得します。
     * - Returns: デフォルトのインデント幅
     */
    public static let defaultIndentationWidth: CGFloat = 20

    /** 
     * デフォルトのアイコンサイズを取得します。
     * - Returns: デフォルトのアイコンサイズ
     */
    public static let defaultIconSize: CGFloat = 20
}
#endif
