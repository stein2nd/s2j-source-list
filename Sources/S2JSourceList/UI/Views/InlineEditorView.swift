//
//  InlineEditorView.swift
//  S2JSourceList
//
//  Created by S2J Source List Generator
//

import SwiftUI

/** 
 * Sourcelist のアイテムの、タイトルをインラインで編集するためのビュー
 */
public struct InlineEditorView: View {

    @Binding var text: String

    let onCommit: () -> Void
    let onCancel: () -> Void

    @FocusState private var isFocused: Bool
    @State private var originalText: String

    /** 
     * インライン編集のイニシャライザー
     * - Parameter text: テキスト
     * - Parameter onCommit: コミット時のアクション
     * - Parameter onCancel: キャンセル時のアクション
     */
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

    /** 
     * インライン編集のボディを返します。
     * - Returns: インライン編集のボディ
     */
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

    /** 
     * インライン編集をコミットします。
     */
    private func commit() {
        onCommit()
    }

    /** 
     * インライン編集をキャンセルします。
     */
    private func cancel() {
        text = originalText
        onCancel()
    }
}
