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
    @State private var nickFieldState: FieldState = .normal
    @FocusState private var focusField: Bool
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
                .padding([.top, .horizontal])
            Spacer()
            SignUpButton("완료", !nickname.isValidNickname.isValid, focusState: focusField) {
                userViewModel.register(id: deviceUUID, nickname: nickname)
                // TODO: 유저 환영 화면 연결 or pop to root
                UserDefaults.standard.set(true, forKey: "isLogined")
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                }
            }
        }
    }

    @ViewBuilder
    private func makeMessageView(nickname: String) -> some View {
        switch nickname.isValidNickname {
        case .normal, .valid:
            VStack(alignment: .leading, spacing: 5) {
                Text("아카데미 내에서 사용중인 닉네임을 권장드려요")
                Text("특수문자와 공백을 제외하고 입력해주세요")
            }
        case .invalid:
            Text("형식에 맞지 않은 닉네임입니다.")
        }
    }

    private func setMessageColor(nickname: String) -> Color {
        switch nickname.isValidNickname {
        case .normal, .valid:
            return Color.signUpYellowGray
        case .invalid:
            return Color.customRed
        }
    }
}

struct SignUpNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpNicknameView().environmentObject(Authentication())
    }
}
