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

    var title: String {
        switch self {
        case .taxiParty:
            return "택시팟"
        case .myParty:
            return "마이팟"
        case .setting:
            return "설정"
        }
    }

    var image: String {
        switch self {
        case .taxiParty:
            return "plus"
        default:
            return ""
        }
    }
}
struct MainView: View {
    @StateObject private var myPartyViewModel: MyPartyView.ViewModel
    @StateObject private var taxiPartyViewModel: TaxiPartyList.ViewModel
    @StateObject private var userInfoState: UserInfoState
    @EnvironmentObject private var appState: AppState

    init(_ userInfo: UserInfo) {
        let listViewModel = MyPartyView.ViewModel(userId: userInfo.id)
        self._myPartyViewModel = StateObject(wrappedValue: listViewModel)
        self._taxiPartyViewModel = StateObject(wrappedValue: TaxiPartyList.ViewModel(addTaxiPartyDelegate: listViewModel, joinTaxiPartyDelegate: listViewModel, exclude: userInfo.id))
        self._userInfoState = StateObject(wrappedValue: UserInfoState(userInfo))
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    var body: some View {
        NavigationView {
            TabView(selection: $appState.tab) {
                TaxiPartyList(taxiPartyViewModel)
                    .navigationTitle(Tab.taxiParty.title)
                    .navigationBarHidden(true)
                    .tabItem {
                        if appState.tab == .taxiParty {
                            Label(Tab.taxiParty.title, image: ImageName.tabTaxiPartyOn)
                        } else {
                            Label(Tab.taxiParty.title, image: ImageName.tabTaxiPartyOff)
                        }
                    }
                    .tag(Tab.taxiParty)
                MyPartyView(myPartyViewModel)
                    .navigationTitle(Tab.myParty.title)
                    .navigationBarHidden(true)
                    .tabItem {
                        if appState.tab == .myParty {
                            Label(Tab.myParty.title, image: ImageName.tabMyPartyOn)
                        } else {
                            Label(Tab.myParty.title, image: ImageName.tabMyPartyOff)
                        }
                    }
                    .tag(Tab.myParty)
                MyPageView()
                    .navigationTitle(Tab.setting.title)
                    .navigationBarHidden(true)
                    .tabItem {
                        if appState.tab == .setting {
                            Label(Tab.setting.title, image: ImageName.tabMyPageOn)
                        } else {
                            Label(Tab.setting.title, image: ImageName.tabMyPageOff)
                        }
                    }
                    .tag(Tab.setting)
            }
        }
        .environmentObject(userInfoState)
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(UserInfo(id: "", nickname: "", profileImage: ""))
            .inject()
    }
}
#endif
