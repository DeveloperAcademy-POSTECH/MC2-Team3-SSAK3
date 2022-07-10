//
//  SignUpNickname.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/09.
//

import SwiftUI

struct SignUpNickname: View {
    @EnvironmentObject private var authentication: Authentication
    @State private var nickname: String = ""
    let email: Email

    var body: some View {
        VStack(alignment: .leading) {
            Text("닉네임을 입력해주세요")
                .signUpTitle()
                .padding()
            UnderlinedTextField(text: .constant("닉네임"), .normal(message: "아카데미 내에서 사용중인 닉네임을 권장드려요"), "닉네임")
                .padding(.horizontal)
                .padding(.top, 48)
            Spacer()
            RoundedButton("회원가입", loading: authentication.isRegisterProcessing) {
                authentication.register(nickname)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct SignUpNicknamePreview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpNickname(email: "")
        }
        .environmentObject(Authentication())
    }
}
