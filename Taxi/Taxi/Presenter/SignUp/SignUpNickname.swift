//
//  SignUpNickname.swift
//  Taxi
//
//  Created by JongHo Park on 2022/08/11.
//

import SwiftUI

struct SignUpNickname: View {

    // MARK: - States
    @State private var nicknameValidation: ValidationResult = .empty(message: "아카데미 내에서 사용중인 닉네임을 권장드려요")
    @FocusState private var nicknameFocusState: Bool
    @ObservedObject private var viewModel: SignUpViewModel
    @Binding private var isSignUpActive: Bool
    init(_ viewModel: SignUpViewModel, _ isSignUpActive: Binding<Bool>) {
        self.viewModel = viewModel
        self._isSignUpActive = isSignUpActive
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: 30)
            Text("닉네임을 입력해주세요")
                .signUpTitle()
                .padding(.horizontal)
            UnderlinedTextField(text: $viewModel.nickname.value, nicknameValidation, "닉네임을 입력해주세요")
                .padding(.top, 64)
                .padding(.horizontal)
                .focused($nicknameFocusState, equals: true)
            Spacer()
            SignUpButton("회원가입", !nicknameValidation.isValid, viewModel.isLoading, focusState: nicknameFocusState) {
                viewModel.register()
            }

            NavigationLink(isActive: .constant(viewModel.registerCompletionEvent)) {
                SignUpComplete(viewModel, $isSignUpActive)
            } label: {
                EmptyView()
            }
            .isDetailLink(false)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onChange(of: viewModel.nickname.value) { _ in
            nicknameValidation = viewModel.nickname.validate()
        }
        .alert(Text("에러발생\n\(viewModel.error?.localizedDescription ?? "알 수 없는 에러")"), isPresented: .constant(viewModel.error != nil)) {
            Button("확인", role: .cancel) {
                viewModel.error = nil
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                nicknameFocusState = true
            }
        }
    }
}

#if DEBUG
// MARK: - Preview
struct SignUpNickname_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpNickname(SignUpViewModel(), .constant(true))
        }
    }
}
#endif
