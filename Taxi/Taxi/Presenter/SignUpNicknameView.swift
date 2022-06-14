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
        NavigationView {
            VStack(alignment: .leading) {
                Text("닉네임을 입력해주세요")
                    .fontWeight(.bold)
                    .opacity(0.3)
                UnderlinedTextField(text: $nickName, nickFieldState, "닉네임을 입력해주세요")
                    .focused($focusField)
                Text("아카데미 내에서 사용중인 닉네임을 권장드려요")
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Button {
                } label: {
                    Text("다음")
                        .frame(maxWidth: .infinity)
                }
                .disabled(nickName.isEmpty)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    focusField = true
                    nickFieldState = .focused
                }
            }
            .onSubmit {
                focusField = true
            }
            .padding()
        }
    }
}

struct SignUpNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpNicknameView()
    }
}
