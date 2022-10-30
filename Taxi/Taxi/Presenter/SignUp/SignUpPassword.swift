//
//  SignUpPassword.swift
//  Taxi
//
//  Created by JongHo Park on 2022/08/11.
//

import SwiftUI

struct SignUpPassword: View {

    // MARK: - States
    @State private var passwordValidation: ValidationResult = .empty(message: "6자 이상 써주세요")
    @ObservedObject private var viewModel: SignUpViewModel
    @FocusState private var passwordFocusState: Bool
    @State private var goToNicknmae: Bool = false

    init(_ viewModel: SignUpViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: 30)
            Text("비밀번호를 입력해주세요")
                .signUpTitle()
                .padding(.horizontal)
            UnderlinedPasswordTextField($viewModel.password.value, passwordValidation, "비밀번호를 입력해주세요")
                .padding(.top, 64)
                .padding(.horizontal)
                .focused($passwordFocusState, equals: true)
            Spacer()
            SignUpButton("닉네임 설정", isDisabled: !passwordValidation.isValid, focusState: passwordFocusState) {
                goToNicknmae = true
            }
            .padding(.bottom, passwordFocusState ? 0 : 16)

            NavigationLink(isActive: $goToNicknmae) {
                SignUpNickname(viewModel)
            } label: {
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onChange(of: viewModel.password.value) { _ in
            passwordValidation = viewModel.password.validate()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                passwordFocusState = true
            }
        }
    }
}

#if DEBUG
// MARK: - Preview
struct SignUpPassword_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpPassword(SignUpViewModel())
        }
    }
}
#endif
