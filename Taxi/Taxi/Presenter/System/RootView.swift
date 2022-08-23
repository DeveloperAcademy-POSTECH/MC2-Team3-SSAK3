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
            case .loading:
                Splash()
            case .succeed:
                MainView(appState.currentUserInfo!.id)
                    .environmentObject(UserInfoState(appState.currentUserInfo!))
            }
        }
        .toast(isShowing: $appState.showToastMessage, message: appState.toastMessage)
        .preferredColorScheme(.light)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(AppState())
    }
}
