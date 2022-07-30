//
//  UnderlinedTextField.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/14.
//

import SwiftUI

enum FieldState {
    case normal(message: String)
    case invalid(message: String)
    case valid(message: String)

    var isValid: Bool {
        switch self {
        case .valid:
            return true
        case .normal, .invalid:
            return false
        }
    }

    @ViewBuilder
    var stateText: some View {
        switch self {
        case .normal(let message):
            Text(message)
                .font(.caption)
                .fontWeight(.regular)
                .foregroundColor(.darkGray)
        case .invalid(let message):
            HStack {
                Image(systemName: "x.circle.fill")
                Text(message)
                    .fontWeight(.regular)
            }
            .font(.caption)
            .foregroundColor(.customRed)
        case .valid(let message):
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text(message)
                    .fontWeight(.regular)
            }
            .font(.caption)
            .foregroundColor(.customGreen)
        }
    }

    // MARK: - func
    func getUnderlineColor() -> Color {
        switch self {
        case .normal:
            return Color.charcoal
        case .invalid:
            return Color.customRed
        case .valid:
            return Color.customGreen
        }
    }
}

struct UnderlinedTextField: View {
    private var inputString: Binding<String>
    private let fieldState: FieldState
    private let placeholder: String
    private let postfixText: String?

    init(text inputString: Binding<String>, _ fieldState: FieldState, _ placeholder: String, postfixText: String? = nil) {
        self.inputString = inputString
        self.fieldState = fieldState
        self.placeholder = placeholder
        self.postfixText = postfixText
    }

    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                HStack {
                    TextField(placeholder, text: inputString)
                        .disableAutocorrection(true)
                    if let postfixText = postfixText {
                        Text(postfixText)
                            .foregroundColor(.signUpYellowGray)
                    }
                }
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(fieldState.getUnderlineColor())
                    .padding(.top, 40)
            }
            fieldState.stateText
        }
    }
}

struct UnderlinedTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UnderlinedTextField(text: .constant(""), .normal(message: "하하하하하"), "placeholder")
                .padding()
            UnderlinedTextField(text: .constant("pjh00098"), .valid(message: "입력"), "이메일을 입력해주세요.", postfixText: "@pos.idserve.net")
                .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
