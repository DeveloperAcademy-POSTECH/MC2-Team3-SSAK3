//
//  SignUpNicknameView.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/14.
//

import SwiftUI

struct SignUpNicknameView: View {
    @EnvironmentObject var userViewModel: Authentication
    @Environment(\.dismiss) private var dismiss
    @State private var nickname = ""
    @State private var nickFieldState: FieldState = .normal(message: "아카데미 내에서 사용중인 닉네임을 권장드려요")
    @FocusState private var focusField: Bool
    @AppStorage("isLogined") private var isLogined: Bool = false
    private let deviceUUID = UIDevice.current.identifierForVendor!.uuidString

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 80) {
                Text("닉네임을 입력해주세요")
                    .signUpTitle()
                UnderlinedTextField(text: $nickname, nickFieldState, "닉네임")
                    .font(Font.custom("AppleSDGothicNeo-Regular", size: 20))
                    .focused($focusField)
            }
            .padding(.horizontal)
            makeMessageView(nickname: nickname)
                .font(Font.custom("AppleSDGothicNeo-Regular", size: 14))
                .foregroundColor(setMessageColor(nickname: nickname))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            Spacer()
            SignUpButton("완료", !nickname.isInValidNickname, focusState: focusField) {
                userViewModel.register(id: deviceUUID, nickname: nickname)
                isLogined = true
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    @ViewBuilder
    private func makeMessageView(nickname: String) -> some View {
        if nickname.isInValidNickname {
            Text("형식에 맞지 않은 닉네임입니다.")
        } else {
            VStack(alignment: .leading, spacing: 5) {
                Text("아카데미 내에서 사용중인 닉네임을 권장드려요")
                Text("특수문자와 공백을 제외하고 입력해주세요")
            }
        }
    }

    private func setMessageColor(nickname: String) -> Color {

        return nickname.isInValidNickname ? Color.customRed : Color.signUpYellowGray
    }
}

struct SignUpNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpNicknameView().environmentObject(Authentication())
    }
}
