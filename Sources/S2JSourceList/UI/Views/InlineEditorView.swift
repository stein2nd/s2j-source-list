//
//  InlineEditorView.swift
//  S2JSourceList
//
//  Created by S2J Source List Generator
//

import SwiftUI

/// Inline editor view for renaming source list items.
public struct InlineEditorView: View {
    @Binding var text: String
    let onCommit: () -> Void
    let onCancel: () -> Void
    
    @FocusState private var isFocused: Bool
    @State private var originalText: String
    
    public init(
        text: Binding<String>,
        onCommit: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        self._text = text
        self.onCommit = onCommit
        self.onCancel = onCancel
        self._originalText = State(initialValue: text.wrappedValue)
    }
    
    public var body: some View {
        TextField("", text: $text)
            .textFieldStyle(.plain)
            .focused($isFocused)
            .onSubmit {
                commit()
            }
            .onAppear {
                isFocused = true
            }
            .onChange(of: isFocused) { newValue in
                if !newValue {
                    // Lost focus - commit if changed, otherwise cancel
                    if text != originalText {
                        commit()
                    } else {
                        cancel()
                    }
                }
            }
    }
    
    private func commit() {
        onCommit()
    }
    
    private func cancel() {
        text = originalText
        onCancel()
    }
}
