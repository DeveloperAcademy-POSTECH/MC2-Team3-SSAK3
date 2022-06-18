//
//  RootView.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/09.
//

import SwiftUI

enum Tab {
    case taxiParty
    case myParty
    case setting
}
struct MainView: View {
    @State private var currentTab: Tab = .taxiParty
    @StateObject private var viewModel: ListViewModel
    private let user: User

    init(_ user: User) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: ListViewModel(userId: user.id))
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    var body: some View {
        NavigationView {
            TabView(selection: $currentTab) {
                TaxiPartyListView()
                    .tabItem {
                        if currentTab == .taxiParty {
                            Label("택시팟", image: ImageName.tabTaxiPartyOn)
                        } else {
                            Label("택시팟", image: ImageName.tabTaxiPartyOff)
                        }
                    }
                    .tag(Tab.taxiParty)
                MyPartyView()
                    .tabItem {
                        if currentTab == .myParty {
                            Label("마이팟", image: ImageName.tabMyPartyOn)
                        } else {
                            Label("마이팟", image: ImageName.tabMyPartyOff)
                        }
                    }
                    .tag(Tab.myParty)
                MyPageView()
                    .tabItem {
                        if currentTab == .setting {
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
        MainView(User(id: "1234", nickname: "", profileImage: ""))
            .environmentObject(Authentication())
    }
}
