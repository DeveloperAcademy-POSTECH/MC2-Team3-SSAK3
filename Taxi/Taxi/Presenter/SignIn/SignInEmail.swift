//
//  SignInEmail.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/08.
//

import SwiftUI

struct SignInEmail: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("이메일을 입력해주세요")
                .signUpTitle()
                .padding()

            UnderlinedTextField(text: .constant("이메일을 입력해주세요"), .normal(message: "인증 및 가입에 활용됩니다."), "", postfixText: "@pos.idserve.net")
                .padding(.top, 64)
                .padding(.horizontal)
            Spacer()
            RoundedButton("다음", false, loading: false) {

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
