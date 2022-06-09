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
            VStack(alignment: .leading, spacing: 0) {
                navigationBar
                NavigationLink {
                     ProfileView()
                } label: {
                    profileSettingButton
                }
                Divider()
                    .padding(.leading)
                Text("알림")
                    .font(.system(size: 15, weight: .medium))
                notificationSetting(label: "채팅 알림", isOn: $chattingNoti)
                notificationSetting(label: "택시팟 완료 알림", isOn: $partyCompleteNoti)
                Divider()
                    .padding(.leading)
                logoffButton(title: "로그아웃", label: "정말 로그아웃 하시겠습니까?", message: "경고문구", isPresented: $isTryLogout) {
                    // Logout
                }
                logoffButton(title: "회원탈퇴", label: "정말 회원탈퇴 하시겠습니까?", message: "경고문구", isPresented: $isTryWithdrawal) {
                    // Withdrawal
                }
                Spacer(minLength: 0)
            }
            .navigationBarHidden(true)
        }
    }
}

extension MyPageView {
    var navigationBar: some View {
        Rectangle()
            .foregroundColor(.white)
            .frame(height: 60)
            .shadow(color: .black.opacity(0.05), radius: 0, x: 0, y: 1)
            .overlay(alignment: .bottomLeading) {
                Text("설정")
                    .font(.system(size: 26, weight: .bold))
        }
    }

    var profileSettingButton: some View {
        HStack {
            Text("프로필 관리")
                .font(.system(size: 17, weight: .bold))
            Spacer()
            Image(systemName: "chevron.right")
        }
    }

    @ViewBuilder
    func notificationSetting(label: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 17, weight: .bold))
            Spacer()
            Toggle(label, isOn: isOn)
                .labelsHidden()
        }
    }

    @ViewBuilder
    func logoffButton(title: String, label: String, message: String, isPresented: Binding<Bool>, action: @escaping () -> Void) -> some View {
        Button(title) {
            isPresented.wrappedValue.toggle()
        }
        .alert(label, isPresented: isPresented) {
            Button("취소", role: .cancel) {
                isPresented.wrappedValue.toggle()
            }
            Button("확인", role: .destructive) {
                action()
            }
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
