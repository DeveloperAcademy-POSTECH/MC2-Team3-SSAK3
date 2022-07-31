//
//  SignUp.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/30.
//

import SwiftUI

struct SignUp: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var signUpViewModel: SignUpViewModel = SignUpViewModel()
    @State private var emailValidation: ValidationResult = .empty(message: "최초 인증 및 가입에 활용됩니다. (영문 대소문자, 숫자)")
    @State private var passwordValidation: ValidationResult = .empty(message: "6자 이상 써주세요")
    @State private var nicknameValidation: ValidationResult = .empty(message: "아카데미 내에서 사용중인 닉네임을 권장드려요")
    @State private var isShowingAlert: Bool = false

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("이메일을 입력해주세요")
                        .signUpTitle()
                    UnderlinedTextField(text: $signUpViewModel.email.value, emailValidation, "아카데미 이메일을 입력해주세요", postfixText: "@pos.idserve.net")
                        .padding(.bottom)
                    Text("비밀번호를 입력해주세요")
                        .signUpTitle()
                    UnderlinedPasswordTextField($signUpViewModel.password.value, passwordValidation, "비밀번호를 입력해주세요")
                        .padding(.bottom)
                    Text("닉네임을 입력해주세요")
                        .signUpTitle()
                    UnderlinedTextField(text: $signUpViewModel.nickname.value, nicknameValidation, "아카데미 닉네임을 입력해주세요")
                        .padding(.bottom)
                }
            }
            .alert("회원가입 성공!\n이메일 인증 후 로그인을 진행해주세요.", isPresented: .constant(signUpViewModel.registerCompletionEvent), actions: {
                Button("확인", role: .cancel) {
                    dismiss()
                }
            })
            .padding()
            Spacer()
            RoundedButton("회원가입", !canRegister(), loading: signUpViewModel.isLoading) {
                signUpViewModel.register()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onChange(of: signUpViewModel.email.value) { _ in
            emailValidation = signUpViewModel.email.validate()
        }
        .onChange(of: signUpViewModel.password.value) { _ in
            passwordValidation = signUpViewModel.password.validate()
        }
        .onChange(of: signUpViewModel.nickname.value) { _ in
            nicknameValidation = signUpViewModel.nickname.validate()
        }
        .onChange(of: signUpViewModel.registerCompletionEvent) { registerCompletionEvent in
            if registerCompletionEvent {
                dismiss()
            }
        }
    }

    private func canRegister() -> Bool {
        switch (emailValidation, passwordValidation, nicknameValidation) {
        case (.valid, .valid, .valid):
            return true
        default:
            return false
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUp()
        }
    }
}
