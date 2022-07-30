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
    @EnvironmentObject private var authentication: UserInfoState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            title
            profile
            Rectangle()
                .fill(Color(red: 240 / 255, green: 240 / 255, blue: 240 / 255))
                .frame(height: 5)
            notificationHeader
            notificationSetting("채팅 알림", isOn: $chattingNoti)
            notificationSetting("택시팟 완료 알림", isOn: $partyCompleteNoti)
            Spacer()
        }
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
    }
}

private extension MyPageView {

    var title: some View {
        Text("설정")
            .font(.custom("AppleSDGothicNeo-Bold", size: 25))
            .padding(.leading)
    }

    var profile: some View {
        HStack(spacing: 13) {
            if let user = authentication.userInfo {
                ProfileImage(user, diameter: 46)
                Text(user.nickname)
                    .foregroundColor(.charcoal)
                    .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
            } else {
                Circle()
                    .strokeBorder(Color.darkGray, lineWidth: 1)
                    .frame(width: 46, height: 46)
            }
            Spacer()
            Button {
                showProfile.toggle()
            } label: {
                Text("프로필 수정")
                    .font(Font.custom("AppleSDGothicNeo-Medium", size: 12))
                    .padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 4))
                    .background(RoundedRectangle(cornerRadius: 5).stroke().fill(Color.customGray))
            }
        }
        .padding(.horizontal)
    }

    var notificationHeader: some View {
        Text("알림")
            .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
            .foregroundColor(.darkGray)
            .padding(.leading)
    }

    func notificationSetting(_ label: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(label)
                .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
                .foregroundColor(.charcoal)
            Spacer()
            Toggle(label, isOn: isOn)
                .labelsHidden()
                .tint(.customYellow)
        }
        .padding(.horizontal)
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
            .environmentObject(UserInfoState(UserInfo(id: "", nickname: "", profileImage: "")))
    }
}
