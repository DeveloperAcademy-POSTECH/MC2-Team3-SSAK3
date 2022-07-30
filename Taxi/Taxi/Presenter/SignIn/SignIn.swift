//
//  SignIn.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/30.
//

import SwiftUI

struct SignIn: View {

    @AppStorage("emailPrefix") private var email: String = ""
    @AppStorage("password") private var password: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("가입하신 아카데미 이메일을 입력해주세요")
                .font(.title3)
                .bold()
                .padding(.horizontal)
            UnderlinedTextField(text: $email, .normal(message: ""), "이메일을 입력해주세요", postfixText: "pos.idserve.net")
                .padding(.horizontal)
            Spacer()
            Text("비밀번호를 입력해주세요")
                .font(.title3)
                .bold()
                .padding(.horizontal)
            UnderlinedPasswordTextField($password, .normal(message: ""), "비밀번호를 입력해주세요")
                .padding(.horizontal)
            Spacer()
            Spacer()
            Spacer()
            RoundedButton("로그인", false, loading: false) {

            }
        }
        .padding(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignIn()
        }
    }
}
