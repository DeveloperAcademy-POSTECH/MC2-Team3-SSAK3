//
//  SignInWaitDeepLink.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/08.
//

import SwiftUI

struct SignInWaitingDeepLink: View {
    @ObservedObject var signManager: SignManager
    @EnvironmentObject private var authentication: Authentication

    var body: some View {
        VStack {
            LottieView(filename: "loadingAnimation")
                .frame(maxWidth: .infinity)
                .frame(height: 300)
            Text("본인 인증을 진행중입니다")
                .foregroundColor(.darkGray)
                .font(.caption)
                .offset(y: -40)
        }
        .onOpenURL { url in
            handleDeepLink(url.absoluteString)
            authentication.login(with: signManager.email)
        }
    }

    private func handleDeepLink(_ url: String) {
        
    }
}

struct SignInWaitingDeepLinkPreview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInWaitingDeepLink(signManager: SignManager())
        }
    }
}
