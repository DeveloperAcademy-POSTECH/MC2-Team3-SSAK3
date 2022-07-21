//
//  SignInEmail.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/08.
//

import SwiftUI

struct SignInEmail: View {
    @EnvironmentObject private var authentication: Authentication
    @State private var email: Email = ""
    private let emailPostfix: String = "@pos.idserve.net"

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("이메일을 입력해주세요")
                .signUpTitle()
                .padding()

            UnderlinedTextField(text: $email, .normal(message: "인증 및 가입에 활용됩니다."), "", postfixText: emailPostfix)
                .padding(.top, 48)
                .padding(.horizontal)
                .textInputAutocapitalization(.never)

            Spacer()

            NavigationLink(isActive: $authentication.waitingDeepLink) {
                SignInWaitingDeepLink(email: email + emailPostfix)
            } label: {
                RoundedButton("인증 메일 보내기") {
                    authentication.sendEmail(email + emailPostfix)
                    authentication.waitingDeepLink = true
                }
            }
            .isDetailLink(false)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct SignInEmailPreview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInEmail()
                .environmentObject(Authentication())
        }
    }
}
