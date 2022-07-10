//
//  SignInEmail.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/08.
//

import SwiftUI

struct SignInEmail: View {
    @ObservedObject private var signManager: SignManager = SignManager()

    @State private var goToNext: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("이메일을 입력해주세요")
                .signUpTitle()
                .padding()

            UnderlinedTextField(text: $signManager.email, .normal(message: "인증 및 가입에 활용됩니다."), "", postfixText: signManager.emailPostfix)
                .padding(.top, 48)
                .padding(.horizontal)
                .textInputAutocapitalization(.never)

            Spacer()

            NavigationLink(isActive: $goToNext) {
                SignInWaitingDeepLink(signManager: signManager)
            } label: {
                RoundedButton("인증 메일 보내기") {
                    signManager.sendEmail()
                    goToNext = true
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct SignInEmailPreview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInEmail()
        }
    }
}
