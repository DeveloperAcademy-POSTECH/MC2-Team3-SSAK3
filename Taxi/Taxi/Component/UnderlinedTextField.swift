//
//  UnderlinedTextField.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/14.
//

import SwiftUI

enum FieldState {
    case notFocused, focused, wrong, right

    var correct: Bool {
        switch self {
        case .right:
            return true
        case .notFocused, .focused, .wrong:
            return false
        }
    }
}

struct UnderlinedTextField: View {
    private var inputString: Binding<String>
    private let fieldState: FieldState
    private let placeholder: String

    init(text inputString: Binding<String>, _ fieldState: FieldState, _ placeholder: String) {
        self.inputString = inputString
        self.fieldState = fieldState
        self.placeholder = placeholder
    }

    var body: some View {
        TextField(placeholder, text: inputString)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .overlay(
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(setUnderlineColor(fieldState))
                    .padding(.top, 50)
                    .padding(.bottom, 20)
            )
    }

    // MARK: - func
    private func setUnderlineColor(_ state: FieldState) -> Color {
        switch state {
        case .notFocused:
            return Color.charcoal
        case .focused:
            return Color.customYellow
        case .wrong:
            return Color.customRed
        case .right:
            return Color.customGreen
        }
    }
}

struct UnderlinedTextField_Previews: PreviewProvider {
    static var previews: some View {
        UnderlinedTextField(text: .constant(""), .notFocused, "placeholder")
    }
}
