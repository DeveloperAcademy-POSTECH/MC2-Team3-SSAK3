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
            if let userInfo = appState.currentUserInfo {
                MainView(userInfo.id)
                    .environmentObject(UserInfoState(userInfo))
            } else {
                OnboardingView()
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
