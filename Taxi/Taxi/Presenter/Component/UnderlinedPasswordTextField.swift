//
//  UnderlinedPasswordTextField.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/30.
//

import SwiftUI

struct UnderlinedPasswordTextField: View {
    private var inputString: Binding<String>
    private let fieldState: FieldState
    private let placeholder: String
    @State private var isShowingPassword: Bool = false

    init(_ inputString: Binding<String>, _ fieldState: FieldState, _ placeholder: String) {
        self.inputString = inputString
        self.fieldState = fieldState
        self.placeholder = placeholder
    }
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                HStack {
                    if !isShowingPassword {
                        SecureField(placeholder, text: inputString)
                    } else {
                        TextField(placeholder, text: inputString)
                    }
                    Spacer()
                    Button {
                        isShowingPassword.toggle()
                    } label: {
                        Image(systemName: !isShowingPassword ? "eye.fill" : "eye.slash.fill")
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

struct UnderlinedPasswordTextField_Previews: PreviewProvider {
    static var previews: some View {
        UnderlinedPasswordTextField(.constant("헤이헤이"), .normal(message: ""), "비밀번호를 입력해주세요")
    }
}
