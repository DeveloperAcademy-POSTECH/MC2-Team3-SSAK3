//
//  SignUpView.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/08.
//

import SwiftUI

struct SignUpView: View {
    @State private var signUpCode: String = ""
    @State private var nickName: String = ""
    @State private var codeIsTrue: Bool = false
    private let developerCode: String = "가즈윌"

    var body: some View {
        VStack(alignment: .leading) {
            Text("가입 코드").fontWeight(.bold).opacity(0.3)
            underlinedTextField($signUpCode)
                .onSubmit {
                    codeIsTrue = (signUpCode == developerCode)
                }
            Text(codeIsTrue ? "✅ 인증 완료되었습니다" : "* 최초 인증 및 가입에 활용됩니다.")
                .font(.caption)
                .foregroundColor(codeIsTrue ? .green : .black.opacity(0.3))
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text("닉네임").fontWeight(.bold).opacity(0.3)
            underlinedTextField($nickName)
            Group {
                Text("* 사용하실 닉네임을 입력해주세요")
                Text("(아카데미 내의 닉네임을 권장드립니다)")
            }.font(.caption).opacity(0.3).frame(maxWidth: .infinity, alignment: .trailing)
            Spacer()
            Button {
                UserDefaults.standard.set(true, forKey: "isLogin")
            } label: {
                    Text("버튼")
                        .frame(maxWidth: .infinity)
                }
                .disabled(!codeIsTrue || nickName.isEmpty)
        }
        .padding()
    }

    private func underlinedTextField( _ inputString: Binding<String>) -> some View {
        TextField("", text: inputString)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .underlineTextField()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
