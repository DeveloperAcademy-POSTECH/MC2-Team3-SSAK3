//
//  SignUp.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/30.
//

import SwiftUI

struct SignUp: View {
    @AppStorage("emailPrefix") private var email: String = ""
    @AppStorage("password") private var password: String = ""
    @State private var nickname: String = ""
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("이메일을 입력해주세요")
                        .signUpTitle()
                    UnderlinedTextField(text: $email, .normal(message: ""), "아카데미 이메일을 입력해주세요", postfixText: "@pos.idserve.net")
                        .padding(.bottom)
                    Text("비밀번호를 입력해주세요")
                        .signUpTitle()
                    UnderlinedPasswordTextField($password, .normal(message: ""), "비밀번호를 입력해주세요")
                        .padding(.bottom)
                    Text("닉네임을 입력해주세요")
                        .signUpTitle()
                    UnderlinedTextField(text: $nickname, .normal(message: ""), "아카데미 닉네임을 입력해주세요")
                        .padding(.bottom)
                }
            }
            .padding()
            Spacer()
            RoundedButton("회원가입", false, loading: false) {

            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUp()
        }
    }
}
