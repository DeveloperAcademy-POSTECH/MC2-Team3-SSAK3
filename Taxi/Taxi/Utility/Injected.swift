//
//  Injected.swift
//  Taxi
//
//  Created by JongHo Park on 2022/08/17.
//

#if DEBUG
import SwiftUI

extension View {
    func inject() -> some View {
        self
            .environmentObject(TaxiPartyList.ViewModel())
            .environmentObject(MyPartyView.ViewModel(userId: "123"))
            .environmentObject(AppState())
            .environmentObject(UserInfoState(UserInfo(id: "", nickname: "", profileImage: nil)))
    }
}
#endif
