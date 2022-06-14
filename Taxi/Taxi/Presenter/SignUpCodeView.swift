//
//  SignUpCodeView.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/14.
//

import SwiftUI

struct SignUpCodeView: View {
    @State private var signUpCode: String = ""
    @State private var codeState: FieldState = .notFocused
    @State private var isActive: Bool = false
    private let developerCode: String = "레몬"
    @FocusState private var focusField: Bool

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 80) {
                Text("가입코드를 입력해주세요")
                    .signUpTitle()
                VStack {
                UnderlinedTextField(text: $signUpCode, codeState, "가입코드를 입력해주세요")
                    .font(Font.custom("AppleSDGothicNeo-Regular", size: 20))
                    .focused($focusField)
                    .disabled(codeState.isCorrect)
                makeMessage(codeState)
                    .font(Font.custom("AppleSDGothicNeo-Regular", size: 14))
                    .foregroundColor(codeFieldMessageColor(codeState))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                }
                Spacer()
                NavigationLink(destination: SignUpNicknameView(), isActive: $isActive) {
                    Text("")
                }
                RoundedButton("다음", !codeState.isCorrect) {
                    isActive.toggle()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    focusField = true
                    codeState = .focused
                }
            }
            .onSubmit {
                codeState = (signUpCode == developerCode ? .right : .wrong)
                focusField = true
            }
            .padding()
        }
    }

    @ViewBuilder
    private func makeMessage( _ fieldText: FieldState) -> some View {
        switch fieldText {
        case .notFocused, .focused:
            HStack {
                Text("최초 인증 및 가입에 활용됩니다")
                Spacer()
                Text("가입코드 받기")
            }
        case .wrong:
            HStack {
                Image(systemName: "x.circle.fill")
                Text("올바른 코드를 입력해주세요")
            }
        case .right:
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("인증 완료되었습니다")
            }
        }
    }

    private func codeFieldMessageColor( _ fieldText: FieldState) -> Color {
        switch fieldText {
        case .notFocused, .focused:
            return Color.signUpYellowGray
        case .wrong:
            return Color.customRed
        case .right:
            return Color.customGreen
        }
    }

    }

struct SignUpCodeView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpCodeView()
    }
}
