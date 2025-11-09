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

/// Provides icon images for source list items.
public struct IconProvider {
    /// Gets an image for the given icon name.
    ///
    /// - Parameter iconName: Icon name (system name or asset name)
    /// - Returns: Image view, or nil if icon name is invalid
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
    
    /// Gets an image for the given icon name with a default fallback.
    ///
    /// - Parameters:
    ///   - iconName: Icon name (system name or asset name)
    ///   - defaultIcon: Default icon name to use if iconName is invalid
    /// - Returns: Image view
    public static func image(for iconName: String?, defaultIcon: String = "folder") -> Image {
        if let image = image(for: iconName) {
            return image
        }
        return Image(systemName: defaultIcon)
    }
}

#if canImport(AppKit)
extension IconProvider {
    /// Gets an NSImage for macOS (for AppKit bridge if needed).
    ///
    /// - Parameter iconName: Icon name
    /// - Returns: NSImage, or nil if icon name is invalid
    public static func nsImage(for iconName: String?) -> NSImage? {
        guard let iconName = iconName, !iconName.isEmpty else { return nil }
        
        if let image = NSImage(systemSymbolName: iconName, accessibilityDescription: nil) {
            return image
        }
        
        return NSImage(named: iconName)
    }
}
#endif
