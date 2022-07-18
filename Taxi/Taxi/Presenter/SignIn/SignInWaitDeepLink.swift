//
//  SignInWaitDeepLink.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/08.
//

import SwiftUI

struct SignInWaitingDeepLink: View {
    @EnvironmentObject private var authentication: Authentication
    let email: Email

    var body: some View {
        VStack {
            LottieView(filename: "loadingAnimation")
                .frame(maxWidth: .infinity)
                .frame(height: 300)
            Text("본인 인증을 진행중입니다")
                .foregroundColor(.darkGray)
                .font(.caption)
                .offset(y: -40)
            NavigationLink(isActive: $authentication.needToRegister) {
                SignUpNickname(email: email)
            } label: {
                EmptyView()
            }
            .isDetailLink(false)
        }
        .onOpenURL { url in
            handleDeepLink(url.absoluteString)
        }
    }

    private func handleDeepLink(_ url: String) {
        UserDefaults.standard.set(url, forKey: "link")
        authentication.checkRegisterHistory(email)
    }
}

struct SignInWaitingDeepLinkPreview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInWaitingDeepLink(email: "")
        }
    }
}
