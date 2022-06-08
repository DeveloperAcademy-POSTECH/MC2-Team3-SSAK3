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

    var body: some View {
        VStack(alignment: .leading) {
            Text("가입 코드").fontWeight(.bold).opacity(0.3)
            makeTextField(self.$signUpCode)
            Text("닉네임").fontWeight(.bold).opacity(0.3)
            makeTextField(self.$nickName)
            Spacer()
            Button(action: {print("button clicked")}){
                Text("버튼")
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
    private func makeTextField( _ inputString: Binding<String>) -> some View {
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
