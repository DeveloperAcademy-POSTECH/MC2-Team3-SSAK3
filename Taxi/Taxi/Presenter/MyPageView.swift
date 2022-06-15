//
//  MyPageView.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/08.
//

import SwiftUI

struct MyPageView: View {
    @AppStorage("chattingNoti") private var chattingNoti: Bool = true
    @AppStorage("partyCompleteNoti") private var partyCompleteNoti: Bool = true
    @State private var isTryLogout: Bool = false
    @State private var isTryWithdrawal: Bool = false
    @State private var showProfile: Bool = false
    @EnvironmentObject var userViewModel: Authentication

    var body: some View {
        VStack(alignment: .leading) {
            Text("설정")
            profile
            Divider()
            Text("알림")
            notificationSetting("채팅 알림", isOn: $chattingNoti)
            notificationSetting("택시팟 완료 알림", isOn: $partyCompleteNoti)
            Divider()
            Spacer(minLength: 0)
        }
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
    }
}

private extension MyPageView {

    var profile: some View {
        HStack {
            if let user = userViewModel.user {
                ProfileImage(user, diameter: 46)
                Text(user.nickname)
            } else {
                Circle().foregroundColor(.lightGray).frame(width: 46, height: 46)
                Rectangle().foregroundColor(.lightGray).frame(width: 60, height: 20)
            }
            Spacer()
            Button {
                showProfile.toggle()
            } label: {
                Text("프로필 수정")
            }
        }
    }

    func notificationSetting(_ label: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(label)
            Spacer()
            Toggle(label, isOn: isOn)
                .labelsHidden()
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
            .environmentObject(Authentication())
    }
}
