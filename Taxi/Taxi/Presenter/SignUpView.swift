//
//  SignUpView.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/08.
//

import SwiftUI

struct SignUpView: View {
    enum Field: Hashable {
        case code, nickname
    }
    enum FieldState {
        case empty, wrong, right

        func isCorrect() -> Bool {
            switch self {
            case .right:
                return true
            case .wrong, .empty:
                return false
            }
        }
    }
    @State private var signUpCode: String = ""
    @State private var nickName: String = ""
    @State private var codeState: FieldState = .empty
    @FocusState private var focusField: Field?
    private let developerCode: String = "레몬"

    var body: some View {
        VStack(alignment: .leading) {
            Text("가입 코드").fontWeight(.bold).opacity(0.3)
            underlinedTextField($signUpCode)
                .focused($focusField, equals: .code)
                .disabled(codeState.isCorrect())
            Text(codeFieldMessage(codeState))
                .font(.caption)
                .foregroundColor(codeFieldMessageColor(codeState))
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text("닉네임").fontWeight(.bold).opacity(0.3)
            underlinedTextField($nickName)
                .focused($focusField, equals: .nickname)
            Group {
                Text("* 사용하실 닉네임을 입력해주세요")
                Text("(아카데미 내의 닉네임을 권장드립니다)")
            }.font(.caption).opacity(0.3).frame(maxWidth: .infinity, alignment: .trailing)
            Spacer()
            Button {
                UserDefaults.standard.set(true, forKey: "isLogined")
            } label: {
                Text("버튼")
                    .frame(maxWidth: .infinity)
            }
            .disabled(!(codeState.isCorrect()) || nickName.isEmpty)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                focusField = .code
            }
        }
        .onSubmit {
            switch focusField {
            case .code:
                codeState = (signUpCode == developerCode ? .right : .wrong)
                guard codeState.isCorrect() else {
                    focusField = .code
                    return
                }
                focusField = .nickname
            case .nickname:
                focusField = nil
            default:
                break
            }
        }
        .padding()
    }

    private func underlinedTextField( _ inputString: Binding<String>) -> some View {
        TextField("", text: inputString)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .underlineTextField()
    }

    private func codeFieldMessage( _ fieldText: FieldState) -> String {
        switch fieldText {
        case .empty:
            return "* 최초 인증 및 가입에 활용됩니다"
        case .wrong:
            return "올바른 코드를 입력해주세요"
        case .right:
            return "✅ 인증 완료되었습니다"
        }
    }

    private func codeFieldMessageColor( _ fieldText: FieldState) -> Color {
        switch fieldText {
        case .empty:
            return Color.black.opacity(0.3)
        case .wrong:
            return Color.red
        case .right:
            return Color.green
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
