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
            VStack(alignment: .trailing) {
                makeTextField(self.$signUpCode) {typedCode in
                    codeIsTrue = (typedCode == developerCode)
                }
                Text(codeIsTrue ? "✅ 인증 완료되었습니다" : "* 최초 인증 및 가입에 활용됩니다.").customTextStyle(isTrue: codeIsTrue)
            }
            Text("닉네임").fontWeight(.bold).opacity(0.3)
            VStack(alignment: .trailing) {
                makeTextField(self.$nickName)
                Group {
                    Text("* 사용하실 닉네임을 입력해주세요").opacity(0.3)
                    Text("(아카데미 내의 닉네임을 권장드립니다)").opacity(0.3)
                }.font(.caption)
            }
            Spacer()
            Button(action: {print("button clicked")}){
                Text("버튼")
                    .frame(maxWidth: .infinity)
                }.disabled(!codeIsTrue || nickName.isEmpty)
        }
        .padding()
    }

    private func makeTextField( _ inputString: Binding<String>, _ codeCheckHandler: ((String) -> Void)? = nil) -> some View {
        TextField("", text: inputString)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .onSubmit {
                codeCheckHandler?(inputString.wrappedValue)
            }
            .underlineTextField()
    }
}

struct CustomTextModifier: ViewModifier {
    var isTrue: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(isTrue ? .green : .black)
            .opacity(isTrue ? 1 : 0.3)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
