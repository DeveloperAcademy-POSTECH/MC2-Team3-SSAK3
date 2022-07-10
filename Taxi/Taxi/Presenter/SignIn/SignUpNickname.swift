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
    @State private var fieldState: FieldState = .normal(message: "아카데미 내에서 사용중인 닉네임을 권장드려요")
    let email: Email

    var body: some View {
        VStack(alignment: .leading) {
            Text("닉네임을 입력해주세요")
                .signUpTitle()
                .padding()
            UnderlinedTextField(text: $nickname, fieldState, "닉네임")
                .padding(.horizontal)
                .padding(.top, 48)
            Spacer()
            RoundedButton("회원가입", loading: authentication.isRegisterProcessing) {
                authentication.register(nickname)
            }
        }
        .onChange(of: nickname, perform: { newValue in
            if newValue.isInValidNickname {
                fieldState = .invalid(message: "사용할 수 없는 닉네임입니다.")
            } else {
                fieldState = .valid(message: "가능한 닉네임입니다.")
            }
        })
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
