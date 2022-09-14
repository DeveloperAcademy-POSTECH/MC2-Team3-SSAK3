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
}
struct MainView: View {
    @StateObject private var myPartyViewModel: MyPartyView.ViewModel
    @StateObject private var taxiPartyViewModel: TaxiPartyList.ViewModel
    @EnvironmentObject private var appState: AppState

    init(_ userId: String) {
        let listViewModel = MyPartyView.ViewModel(userId: userId)
        self._myPartyViewModel = StateObject(wrappedValue: listViewModel)
        self._taxiPartyViewModel = StateObject(wrappedValue: TaxiPartyList.ViewModel(addTaxiPartyDelegate: listViewModel, joinTaxiPartyDelegate: listViewModel, exclude: userId))
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    var body: some View {
        NavigationView {
            TabView(selection: $appState.tab) {
                TaxiPartyList(taxiPartyViewModel)
                    .navigationTitle("택시팟")
                    .navigationBarHidden(true)
                    .tabItem {
                        if appState.tab == .taxiParty {
                            Label("택시팟", image: ImageName.tabTaxiPartyOn)
                        } else {
                            Label("택시팟", image: ImageName.tabTaxiPartyOff)
                        }
                    }
                    .tag(Tab.taxiParty)
                MyPartyView(myPartyViewModel)
                    .navigationTitle("마이팟")
                    .navigationBarHidden(true)
                    .tabItem {
                        if appState.tab == .myParty {
                            Label("마이팟", image: ImageName.tabMyPartyOn)
                        } else {
                            Label("마이팟", image: ImageName.tabMyPartyOff)
                        }
                    }
                    .tag(Tab.myParty)
                MyPageView()
                    .navigationTitle("설정")
                    .navigationBarHidden(true)
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
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView("")
            .inject()
    }
}
#endif
