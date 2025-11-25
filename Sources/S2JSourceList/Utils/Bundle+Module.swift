//
//  Bundle+Module.swift
//  S2JSourceList
//
//  Created by S2J Source List Generator
//

import Foundation

/**
 * Bundle.module の代替実装
 * Xcode プロジェクトで使用する場合のみ有効になります
 * Swift Package Manager では Bundle.module が自動的に提供されるため、
 * この拡張は Xcode プロジェクトでのみ必要です
 */
#if !SWIFT_PACKAGE
extension Bundle {
    /**
     * モジュールのバンドルを取得します。
     * Xcode プロジェクトでは Bundle.module が使用できないため、
     * Bundle(for:) を使用してモジュールのバンドルを取得します。
     * 
     * この実装により、Xcode プロジェクトでもローカライズされたリソースに
     * アクセスできます。
     */
    static var module: Bundle {
        return Bundle(for: BundleFinder.self)
    }
    
    /**
     * バンドルを見つけるための内部クラス
     */
    private class BundleFinder {}
}
#endif

