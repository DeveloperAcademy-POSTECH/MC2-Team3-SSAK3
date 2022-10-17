//
//  ResetPassword.swift
//  Taxi
//
//  Created by 이윤영 on 2022/10/17.
//

import SwiftUI
struct ResetPassword: View {
    @StateObject private var resetPasswordViewModel: ResetPasswordViewModel = ResetPasswordViewModel()
    @State private var isShowingAlert: Bool = false
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(alignment: .leading) {
            Text("가입하신 아카데미 이메일을 입력해주세요")
                .font(.title3)
                .bold()
                .padding(.horizontal)
            UnderlinedTextField(text: $resetPasswordViewModel.email.value, .empty(message: ""), "이메일을 입력해주세요", postfixText: "@pos.idserve.net")
                .padding(.horizontal)
            Spacer()
            RoundedButton("비밀번호 재설정 메일 발송", false, loading: resetPasswordViewModel.isLoading) {
                resetPasswordViewModel.sendPasswordResetMail(onSuccess: {
                    appState.showToastMessage("비밀번호 재설정 이메일이 전송되었어요")
                }, onError: {
                    isShowingAlert = true
                    print(isShowingAlert)
                })
            }
            .padding()
        }
        .alert(resetPasswordViewModel.error?.localizedDescription ?? "알 수 없는 에러", isPresented: $isShowingAlert) {
            Button("확인", role: .cancel) {
                isShowingAlert = false
            }
        }
    }
}

#if DEBUG
// MARK: - Preview
struct ResetPassword_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ResetPassword()
        }
        .environmentObject(AppState())
    }
}
#endif
