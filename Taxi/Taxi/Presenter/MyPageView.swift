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
    @State private var user: User?
    @EnvironmentObject var userViewModel: Authentication

    var body: some View {
        VStack(alignment: .leading) {
            Text("설정")
            HStack {
                if let user = user {
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
            Divider()
            Text("알림")
            notificationSetting("채팅 알림", isOn: $chattingNoti)
            notificationSetting("택시팟 완료 알림", isOn: $partyCompleteNoti)
            Divider()
            logOnStateButton("로그아웃", label: "정말 로그아웃 하시겠습니까?", message: "경고문구", isPresented: $isTryLogout) {
                // TODO: Add Logout Action
            }
            logOnStateButton("회원탈퇴", label: "정말 회원탈퇴 하시겠습니까?", message: "경고문구", isPresented: $isTryWithdrawal) {
                // TODO: Add Withdrawal Action
            }
            Spacer(minLength: 0)
        }
        .sheet(isPresented: $showProfile) {
            ProfileView(user: $user)
        }
        .onAppear {
            user = userViewModel.user
        }
    }
}

extension MyPageView {

    private func notificationSetting(_ label: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(label)
            Spacer()
            Toggle(label, isOn: isOn)
                .labelsHidden()
        }
    }

    private func logOnStateButton(_ title: String, label: String, message: String, isPresented: Binding<Bool>, action: @escaping () -> Void) -> some View {
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
            .environmentObject(Authentication())
    }
}
