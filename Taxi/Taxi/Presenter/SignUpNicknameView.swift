//
//  SignUpNicknameView.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/14.
//

import SwiftUI

struct SignUpNicknameView: View {
    @State private var nickName: String = ""
    @State private var nickFieldState: FieldState = .notFocused
    @FocusState private var focusField: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 80) {
            Text("닉네임을 입력해주세요")
                .signUpTitle()
            VStack {
            UnderlinedTextField(text: $nickName, nickFieldState, "닉네임을 입력해주세요")
                .font(Font.custom("AppleSDGothicNeo-Regular", size: 20))
                .focused($focusField)
                        Text("아카데미 내에서 사용중인 닉네임을 권장드려요")
                .signUpExplain()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
            }
            Spacer()
            RoundedButton("다음", nickName.isEmpty) {
                // TODO: usecase 연결
                UserDefaults.standard.set(true, forKey: "isLogined")
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                focusField = true
                nickFieldState = .focused
            }
        }
        .onSubmit {
            focusField = true
        }
        .padding(.horizontal)
    }
}

struct SignUpNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpNicknameView()
    }
}
