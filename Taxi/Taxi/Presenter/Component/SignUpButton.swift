//
//  SignUpButton.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/16.
//

import SwiftUI

struct SignUpButton: View {
    private let text: String
    private let isDisabled: Bool
    private let isLoading: Bool
    private let focusState: Bool
    private let action: () -> Void

    init(_ title: String, isDisabled: Bool = false, isLoading: Bool = false, focusState isFocuesd: Bool, action: @escaping () -> Void) {
        self.text = title
        self.isDisabled = isDisabled
        self.focusState = isFocuesd
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
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.3 : 1)
        .buttonStyle(.plain)
    }
}

#if DEBUG
// MARK: - Preview
struct SignUpButton_Previews: PreviewProvider {
    static var previews: some View {
        SignUpButton("다음", focusState: true) {

        }
    }
}
#endif
