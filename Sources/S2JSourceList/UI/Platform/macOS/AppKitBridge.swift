//
//  AppKitBridge.swift
//  S2JSourceList
//
//  Created by S2J Source List Generator
//

#if os(macOS)
import AppKit
import SwiftUI

/// AppKit bridge utilities for macOS-specific functionality.
public struct AppKitBridge {
    /// Gets the current accent color from AppKit.
    public static var accentColor: Color {
        Color(NSColor.controlAccentColor)
    }
    
    /// Gets the current window background color.
    public static var windowBackgroundColor: Color {
        Color(NSColor.windowBackgroundColor)
    }
    
    /// Gets the current text color.
    public static var textColor: Color {
        Color(NSColor.textColor)
    }
    
    /// Gets the current secondary text color.
    public static var secondaryTextColor: Color {
        Color(NSColor.secondaryLabelColor)
    }
}
#endif
