//
//  SignUpCodeView.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/14.
//

import SwiftUI

struct SignUpCodeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var signUpCode: String = ""
    @State private var codeState: FieldState = .normal
    @State private var isActive: Bool = false
    private let developerCode: String = "popopot"
    @FocusState private var focusField: Bool

    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 80) {
                    Text("가입코드를 입력해주세요")
                        .signUpTitle()
                    UnderlinedTextField(text: $signUpCode, codeState, "가입코드")
                        .font(Font.custom("AppleSDGothicNeo-Regular", size: 20))
                        .focused($focusField)
                        .disabled(codeState.isValid)
                }
                .padding(.horizontal)
                makeMessage(codeState)
                    .font(Font.custom("AppleSDGothicNeo-Regular", size: 14))
                    .foregroundColor(codeFieldMessageColor(codeState))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.top, .horizontal])
                Spacer()
                NavigationLink(destination: SignUpNicknameView(), isActive: $isActive) {
                }
                makeConditionalButton("다음", !codeState.isValid, focusField) {
                    isActive.toggle()
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
                codeState = (signUpCode == developerCode ? .valid : .invalid)
            }
        }
    }

    @ViewBuilder
    private func makeMessage( _ fieldText: FieldState) -> some View {
        switch fieldText {
        case .normal:
            HStack {
                Text("최초 인증 및 가입에 활용됩니다")
            }
        case .invalid:
            HStack {
                Image(systemName: "x.circle.fill")
                Text("올바른 코드를 입력해주세요")
            }
        case .valid:
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("인증 완료되었습니다")
            }
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

    private func codeFieldMessageColor( _ fieldText: FieldState) -> Color {
        switch fieldText {
        case .normal:
            return Color.signUpYellowGray
        case .invalid:
            return Color.customRed
        case .valid:
            return Color.customGreen
        }
    }

    }

struct SignUpCodeView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpCodeView()
    }
}
