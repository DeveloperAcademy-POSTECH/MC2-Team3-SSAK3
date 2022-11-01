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
    @State private var isShowAccountModal: Bool = false
    @State private var isLicenseNavigationView: Bool = false
    @State private var showProfile: Bool = false
    @State private var isTryingDeleteUser: Bool = false
    @EnvironmentObject private var authentication: UserInfoState
    @EnvironmentObject private var appState: AppState
    @StateObject private var accountViewModel: AccountViewModel = AccountViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Header(.setting)
            profile
            Rectangle()
                .fill(Color(red: 240 / 255, green: 240 / 255, blue: 240 / 255))
                .frame(height: 5)
            Group {
                notificationHeader
                notificationSetting("채팅 알림", isOn: $chattingNoti)
                notificationSetting("택시팟 완료 알림", isOn: $partyCompleteNoti)
            }
            Rectangle()
                .fill(Color(red: 240 / 255, green: 240 / 255, blue: 240 / 255))
                .frame(height: 5)
            Group {
                sendToDeveloper
                opensourceLicense
            }
            Rectangle()
                .fill(Color(red: 240 / 255, green: 240 / 255, blue: 240 / 255))
                .frame(height: 5)
            Group {
                accountButton
                logoutButton
                deleteUserButton
            }
            Spacer()
        }
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
        .sheet(isPresented: $isShowAccountModal, content: {
            AccountSetting(viewModel: accountViewModel)
        })
        .onChange(of: authentication.goToHomeEvent) { newValue in
            if newValue {
                appState.logout()
            }
        }
        .alert("회원 탈퇴하시겠습니까?", isPresented: $isTryingDeleteUser) {
            Button("탈퇴", role: .destructive) {
                authentication.deleteUser()
            }
                .foregroundColor(.customRed)
            Button("취소", role: .cancel) {
                isTryingDeleteUser = false
            }
        }
        .alert("로그아웃 하시겠습니까?", isPresented: $isTryLogout) {
            Button("로그아웃", role: .destructive) {
                appState.logout()
            }
            .foregroundColor(.customRed)
            Button("취소", role: .cancel) {
                isTryLogout = false
            }
        }
    }
}

private extension MyPageView {

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

    var sendToDeveloper: some View {
        Button {
            EmailHelper.shared.send(subject: "[popopot]", body: "[제안 내용]", recipient: ["popopothelp@gmail.com"])
        } label: {
            Text("개발자에게 의견 남기기")
                .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
                .padding()
        }
    }

    var opensourceLicense: some View {
        NavigationLink(destination: LicenseView()) {
                Text("오픈소스 라이선스")
                    .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
                    .padding()
            }
    }

    var deleteUserButton: some View {
        Button {
            isTryingDeleteUser = true
        } label: {
            Text("회원탈퇴")
                .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
                .foregroundColor(.customRed)
                .padding()
        }
    }

    var logoutButton: some View {
        Button {
            isTryLogout = true
        } label: {
            Text("로그아웃")
                .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
                .padding(.top)
                .padding(.horizontal)
        }
    }

    var accountButton: some View {
        Button {
            isShowAccountModal = true
        } label: {
            HStack(alignment: .center) {
                Text("계좌번호")
                    .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
                Spacer()
                Group {
                    if let account = accountViewModel.account {
                        Text(account.bank.rawValue)
                            .foregroundColor(.darkGray)
                    } else {
                        Text("등록해서 편하게 정산하세요!")
                            .foregroundColor(.darkGray)
                    }
                }
            }
            .padding(.top)
            .padding(.horizontal)
            .contentShape(Rectangle())
        }
    }
}

#if DEBUG
struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
            .inject()
    }
}
#endif
