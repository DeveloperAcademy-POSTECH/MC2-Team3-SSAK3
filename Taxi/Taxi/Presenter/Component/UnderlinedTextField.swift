//
//  UnderlinedTextField.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/14.
//

import SwiftUI

enum FieldState {
    case normal, invalid, valid
    var isValid: Bool {
        switch self {
        case .valid:
            return true
        case .normal, .invalid:
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
            .disableAutocorrection(true)
            .overlay(
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(setUnderlineColor(fieldState))
                    .padding(.top, 40)
            )
    }

    // MARK: - func
    private func setUnderlineColor(_ state: FieldState) -> Color {
        switch state {
        case .normal:
            return Color.charcoal
        case .invalid:
            return Color.customRed
        case .valid:
            return Color.customGreen
        }
    }
}

struct UnderlinedTextField_Previews: PreviewProvider {
    static var previews: some View {
        UnderlinedTextField(text: .constant(""), .normal, "placeholder")
    }
}
