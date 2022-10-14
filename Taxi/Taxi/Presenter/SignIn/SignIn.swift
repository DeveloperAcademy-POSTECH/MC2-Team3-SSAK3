//
//  SignIn.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/30.
//

import SwiftUI

struct SignIn: View {

    @ObservedObject var signInViewModel: SignInViewModel
    @State private var isShowingAlert: Bool = false
    @EnvironmentObject private var appState: AppState
    private let signUpEmail: String
    private let signUpPassword: String

    init(
        signInViewModel: SignInViewModel
    ) {
        self.signInViewModel = signInViewModel
        self.signUpEmail = ""
        self.signUpPassword = ""
    }

    init(
        signInViewModel: SignInViewModel,
        signUpEmail: String,
        signUpPassword: String
    ) {
        self.signInViewModel = signInViewModel
        self.signUpEmail = signUpEmail
        self.signUpPassword = signUpPassword
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("가입하신 아카데미 이메일을 입력해주세요")
                .font(.title3)
                .bold()
                .padding(.horizontal)
            UnderlinedTextField(text: $signInViewModel.email.value, .empty(message: ""), "이메일을 입력해주세요", postfixText: "@pos.idserve.net")
                .padding(.horizontal)
            Spacer()
            Text("비밀번호를 입력해주세요")
                .font(.title3)
                .bold()
                .padding(.horizontal)
            UnderlinedPasswordTextField($signInViewModel.password.value, .empty(message: ""), "비밀번호를 입력해주세요")
                .padding(.horizontal)
            HStack {
                Text("비밀번호를 잊으셨나요?")
                    .signUpExplain()
                NavigationLink {
                    ResetPassword()
                } label: {
                    Text("비밀번호 재설정")
                        .underline()
                        .foregroundColor(.customBlack)
                        .signUpExplain()
                }
            }
            .padding(.horizontal)
            Spacer()
            Spacer()
            Spacer()
            RoundedButton("로그인", false, loading: signInViewModel.isLoading) {
                signInViewModel.login()
            }
            .padding()
        }
        .padding(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onReceive(signInViewModel.$error) { error in
            if error != nil {
                isShowingAlert = true
            }
        }
        .alert(signInViewModel.error?.localizedDescription ?? "알 수 없는 에러", isPresented: $isShowingAlert) {
            Button("확인", role: .cancel) {
                isShowingAlert = false
            }
        }
        .onReceive(signInViewModel.$userInfo) { userInfo in
            if let userInfo = userInfo {
                appState.loginState = .succeed(userInfo)
            }
        }
        .onAppear {
            signInViewModel.email.value = signUpEmail
            signInViewModel.password.value = signUpPassword
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignIn(signInViewModel: SignInViewModel())
        }
        .environmentObject(AppState())
    }
}
