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
        if let userInfo = authentication.userInfo {
            MainView(userInfo.id)
                .preferredColorScheme(.light)
        } else {
            OnboardingView()
                .preferredColorScheme(.light)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(Authentication())
    }
}
