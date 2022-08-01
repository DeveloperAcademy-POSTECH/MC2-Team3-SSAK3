//
//  RootView.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/09.
//

import FirebaseAuth
import SwiftUI

enum Tab {
    case taxiParty
    case myParty
    case setting
}
struct MainView: View {
    @StateObject private var viewModel: ListViewModel
    @EnvironmentObject private var appState: AppState

    init(_ userId: String) {
        self._viewModel = StateObject(wrappedValue: ListViewModel(userId: userId))
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    var body: some View {
        NavigationView {
            TabView(selection: $appState.tab) {
                TaxiPartyListView()
                    .tabItem {
                        if appState.tab == .taxiParty {
                            Label("택시팟", image: ImageName.tabTaxiPartyOn)
                        } else {
                            Label("택시팟", image: ImageName.tabTaxiPartyOff)
                        }
                    }
                    .tag(Tab.taxiParty)
                MyPartyView()
                    .tabItem {
                        if appState.tab == .myParty {
                            Label("마이팟", image: ImageName.tabMyPartyOn)
                        } else {
                            Label("마이팟", image: ImageName.tabMyPartyOff)
                        }
                    }
                    .tag(Tab.myParty)
                MyPageView()
                    .tabItem {
                        if appState.tab == .setting {
                            Label("설정", image: ImageName.tabMyPageOn)
                        } else {
                            Label("설정", image: ImageName.tabMyPageOff)
                        }
                    }
                    .tag(Tab.setting)
            }
        }
        .environmentObject(viewModel)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView("")
            .environmentObject(UserInfoState(
            UserInfo(id: "", nickname: "", profileImage: "")))
            .environmentObject(AppState())
    }
}
