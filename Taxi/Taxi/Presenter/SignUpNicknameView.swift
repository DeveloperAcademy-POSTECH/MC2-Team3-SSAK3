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
    @State private var nickName: String = ""
    @State private var nickFieldState: FieldState = .notFocused
    @FocusState private var focusField: Bool
    private let deviceUUID = UIDevice.current.identifierForVendor!.uuidString

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 80) {
                Text("닉네임을 입력해주세요")
                    .signUpTitle()
                UnderlinedTextField(text: $nickName, nickFieldState, "닉네임")
                    .font(Font.custom("AppleSDGothicNeo-Regular", size: 20))
                    .focused($focusField)
                // TODO: 특수 문자 및 공백 체크
            }
            .padding(.horizontal)
            Text("아카데미 내에서 사용중인 닉네임을 권장드려요")
                .signUpExplain()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .horizontal])
            Spacer(minLength: 0)
            makeConditionalButton("완료", nickName.isEmpty, focusField) {
                print("완료버튼 눌림")
                userViewModel.register(id: deviceUUID, nickname: nickName)
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
        .onSubmit {
            focusField = true
        }
    }

    @ViewBuilder
    private func makeConditionalButton(_ title: String, _ disabled: Bool = false, _ focusState: Bool, action: @escaping () -> Void) -> some View {
        if focusState {
            FlatButton(title, disabled, action: action)
        } else {
            RoundedButton(title, disabled, action: action)
        }
    }

}

struct SignUpNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpNicknameView().environmentObject(Authentication())
    }
}
