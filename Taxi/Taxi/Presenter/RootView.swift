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
        if let userInfo = appState.currentUserInfo {
            MainView(userInfo.id)
                .environmentObject(UserInfoState(userInfo))
        } else {
            OnboardingView()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(AppState())
    }
}
