//
//  SignHome.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/30.
//

import SwiftUI

struct SignHome: View {

    // MARK: - States
    @StateObject private var signInViewModel: SignInViewModel = SignInViewModel()
    @State private var isSignUpActive: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            title
            description
            Spacer()
            taxiImage
            Spacer()
            buttons
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .navigationTitle("시작화면")
        .navigationBarHidden(true)
        .padding()
        .padding(.top, 50)
    }
}

// MARK: - UI components
private extension SignHome {
    var title: some View {
        Text("준비되셨나요?")
            .signUpTitle()
    }

    var description: some View {
        Text("포포팟\(Image(systemName: "sparkle"))")
            .foregroundColor(.customYellow) + Text("으로 편하게 택시팟을 이용하세요")
            .foregroundColor(.signUpYellowGray)
    }

    var taxiImage: some View {
        Image("TaxiImage")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: 200, alignment: .center)
            .offset(x: -20)
    }

    var loginDescription: some View {
        Text("입력하신 이메일 주소로 보낸\n본인 인증 메일을 확인 후 로그인 해주세요")
            .foregroundColor(.charcoal)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
    }

    var buttons: some View {
        HStack(spacing: 10) {
            NavigationLink(isActive: $isSignUpActive) {
                SignUpEmail(isSignUpActive: $isSignUpActive)
            } label: {
                Text("회원가입")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.customYellow, in: RoundedRectangle(cornerRadius: 15))
            }
            .isDetailLink(false)

            NavigationLink {
                SignIn(signInViewModel: signInViewModel)
            } label: {
                Text("로그인")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.customYellow, in: RoundedRectangle(cornerRadius: 15))
            }
        }
    }
}

struct SignHome_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignHome()
        }
    }
}
