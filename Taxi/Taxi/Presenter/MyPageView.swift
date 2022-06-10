//
//  MyPageView.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/08.
//

import SwiftUI

struct MyPageView: View {
    @AppStorage("chattingNoti") var chattingNoti: Bool = true
    @AppStorage("partyCompleteNoti") var partyCompleteNoti: Bool = true
    @State private var isTryLogout: Bool = false
    @State private var isTryWithdrawal: Bool = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("설정")
                NavigationLink {
                    ProfileView()
                } label: {
                    linkToProfile
                }
                Divider()
                Text("알림")
                notificationSetting("채팅 알림", isOn: $chattingNoti)
                notificationSetting("택시팟 완료 알림", isOn: $partyCompleteNoti)
                Divider()
                logonStateButton("로그아웃", label: "정말 로그아웃 하시겠습니까?", message: "경고문구", isPresented: $isTryLogout) {
                    // Logout Action
                }
                logonStateButton("회원탈퇴", label: "정말 회원탈퇴 하시겠습니까?", message: "경고문구", isPresented: $isTryWithdrawal) {
                    // Withdrawal Action
                }
                Spacer(minLength: 0)
            }
            .navigationBarHidden(true)
        }
    }
}

extension MyPageView {

    var linkToProfile: some View {
        HStack {
            Text("프로필 관리")
            Spacer()
            Image(systemName: "chevron.right")
        }
    }

    @ViewBuilder
    func notificationSetting(_ label: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(label)
            Spacer()
            Toggle(label, isOn: isOn)
                .labelsHidden()
        }
    }

    @ViewBuilder
    func logonStateButton(_ title: String, label: String, message: String, isPresented: Binding<Bool>, action: @escaping () -> Void) -> some View {
        Button {
            isPresented.wrappedValue.toggle()
        } label: {
            Text(title)
        }
        .alert(label, isPresented: isPresented) {
            Button("취소", role: .cancel) {
                isPresented.wrappedValue.toggle()
            }
            Button("확인", role: .destructive, action: action)
        } message: {
            Text(message)
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
