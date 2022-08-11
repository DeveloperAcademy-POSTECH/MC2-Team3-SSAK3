//
//  SignUpButton.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/16.
//

import SwiftUI

struct SignUpButton: View {
    private let text: String
    private let disabled: Bool
    private let isLoading: Bool
    private let focusState: Bool
    private let action: () -> Void

    init(_ title: String, _ disabled: Bool = false, _ isLoading: Bool = false, focusState: Bool, action: @escaping () -> Void) {
        self.text = title
        self.disabled = disabled
        self.focusState = focusState
        self.action = action
        self.isLoading = isLoading
    }

    var body: some View {
        Button(action: action) {
            ZStack {
                Text(text)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity)
                    .opacity(isLoading ? 0 : 1)
                    .background(Color.customYellow, in: RoundedRectangle(cornerRadius: focusState ? 0 : 15))
                    .padding(.horizontal, focusState ? 0 : 16)
                if isLoading {
                    ProgressView()
                }
            }
        }
        .disabled(disabled || isLoading)
        .opacity(disabled ? 0.3 : 1)
        .buttonStyle(.plain)
    }
}
struct SignUpButton_Previews: PreviewProvider {
    static var previews: some View {
        SignUpButton("다음", focusState: true) {}
        SignUpButton("회원가입", true, true, focusState: true) {}
    }
}
