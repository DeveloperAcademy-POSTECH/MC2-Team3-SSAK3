//
//  RootView.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/17.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var authentication: Authentication

    var body: some View {
        if let user = authentication.user {
            MainView(user)
        } else {
            // TODO: skipOnBoarding에 따른 처리
            OnboardingView()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
