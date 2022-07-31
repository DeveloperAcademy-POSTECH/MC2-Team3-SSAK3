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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("가입하신 아카데미 이메일을 입력해주세요")
                .font(.title3)
                .bold()
                .padding(.horizontal)
            UnderlinedTextField(text: $signInViewModel.email.value, .empty(message: ""), "이메일을 입력해주세요", postfixText: "pos.idserve.net")
                .padding(.horizontal)
            Spacer()
            Text("비밀번호를 입력해주세요")
                .font(.title3)
                .bold()
                .padding(.horizontal)
            UnderlinedPasswordTextField($signInViewModel.password.value, .empty(message: ""), "비밀번호를 입력해주세요")
                .padding(.horizontal)
            Spacer()
            Spacer()
            Spacer()
            RoundedButton("로그인", false, loading: signInViewModel.isLoading) {
                signInViewModel.login()
            }
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
                appState.currentUserInfo = userInfo
            }
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
