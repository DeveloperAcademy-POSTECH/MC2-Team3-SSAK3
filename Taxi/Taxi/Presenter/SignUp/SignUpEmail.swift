//
//  SignUpEmail.swift
//  Taxi
//
//  Created by JongHo Park on 2022/08/11.
//

import SwiftUI

struct SignUpEmail: View {

    // MARK: - State
    @State private var emailValidation: ValidationResult = .empty(message: "최초 인증 및 가입에 활용됩니다. (영문 대소문자, 숫자)")
    @StateObject private var viewModel: SignUpViewModel = SignUpViewModel()
    @FocusState private var emailFocuseState: Bool
    @Binding var isSignUpActive: Bool
    @State private var goToPassword: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: 30)
            Text("이메일을 입력해주세요")
                .signUpTitle()
                .padding(.horizontal)
            UnderlinedTextField(text: $viewModel.email.value, emailValidation, "아카데미 이메일을 입력해주세요", postfixText: "@pos.idserve.net")
                .padding(.top, 64)
                .padding(.horizontal)
                .focused($emailFocuseState, equals: true)
            Spacer()
            SignUpButton("비밀번호 설정", isDisabled: !emailValidation.isValid, focusState: emailFocuseState) {
                goToPassword = true
            }
            .padding(.bottom, emailFocuseState ? 0 : 16)
            NavigationLink(isActive: $goToPassword) {
                SignUpPassword(viewModel, $isSignUpActive)
            } label: {
                EmptyView()
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onChange(of: viewModel.email.value) { _ in
            emailValidation = viewModel.email.validate()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                emailFocuseState = true
            }
        }
    }
}

// MARK: - Preview
#if DEBUG
struct SignUpEmail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpEmail(isSignUpActive: .constant(true))
        }
    }
}
#endif
