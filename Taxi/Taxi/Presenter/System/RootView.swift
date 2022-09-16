//
//  RootView.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/17.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        Group {
            switch appState.loginState {
            case .none:
                OnboardingView()
                    .preferredColorScheme(.light)
            case .loading:
                Splash()
                    .preferredColorScheme(.dark)
            case .succeed(let userInfo):
                MainView(userInfo)
                    .preferredColorScheme(.light)
            }
        }
        .toast(isShowing: $appState.showToastMessage, message: appState.toastMessage)
        .alert("자동 로그인에 실패했어요", isPresented: $appState.isLoginFailed) {
            Button("확인", role: .cancel) {
                appState.loginState = .none
            }
        } message: {
            Text("다시 로그인해보세요.")
        }
    }
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(AppState())
    }
}
#endif
