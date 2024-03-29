//
//  TaxiPartyInfoView.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/11.
//

import SwiftUI

struct TaxiPartyInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userViewModel: UserInfoState
    @EnvironmentObject private var listViewModel: ListViewModel
    @EnvironmentObject private var appState: AppState
    @Binding var showBlur: Bool
    @State private var isLoading: Bool = false
    let taxiParty: TaxiParty
    private let profileSize: CGFloat = 62
    private let remainSeat: Int

    init(taxiParty: TaxiParty, showBlur: Binding<Bool>) {
        self.taxiParty = taxiParty
        self.remainSeat = taxiParty.maxPersonNumber - taxiParty.members.count
        self._showBlur = showBlur
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea()
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 16) {
                    dismissButton
                    Spacer()
                    participatingCount
                    ForEach(0..<taxiParty.members.count, id: \.self) { index in
                        PartyMemberInfo(taxiParty.members[index], diameter: profileSize)
                    }
                    ForEach(0..<remainSeat, id: \.self) { _ in
                        emptyProfile
                    }
                    divider
                    taxiPartyDate
                    taxiPartyTime
                }
                taxiPartyPlace
                roundedButton("시작하기", loading: isLoading)
                    .padding(.top)
            }
            .padding()
        }
        .clearBackground()
    }
}

// MARK: - 뷰 변수

private extension TaxiPartyInfoView {

    var dismissButton: some View {
        HStack {
            Button {
                dismissWithBlurOff()
            } label: {
                Image(systemName: "xmark")
                    .imageScale(.large)
            }
            .tint(.white)
            Spacer()
        }
    }

    var participatingCount: some View {
        HStack {
            Text("참여중인 멤버")
                .font(Font.custom("AppleSDGothicNeo-Medium", size: 15))
                .foregroundColor(.white)
            Rectangle().frame(width: 1, height: 12).foregroundColor(Color(red: 187 / 255, green: 187 / 255, blue: 187 / 255))
            Image(systemName: "person.fill")
                .foregroundColor(.customYellow)
            Text("\(taxiParty.members.count) / \(taxiParty.maxPersonNumber)")
                .foregroundColor(.customYellow)
            Spacer()
        }
    }

    var emptyProfile: some View {
        HStack(spacing: 20) {
            Circle()
                .stroke(.white)
                .frame(width: profileSize, height: profileSize)
                .overlay(Image(systemName: "person.fill").font(.system(size: 30)).foregroundColor(.white))
                .background(Circle().fill(Color.gray))
            Text("택시팟에 참여해보세요!")
                .foregroundColor(.white)
            Spacer()
        }
    }

    var divider: some View {
        Rectangle().foregroundColor(Color(red: 151 / 255, green: 151 / 255, blue: 151 / 255)).frame(height: 1)
    }

    var taxiPartyDate: some View {
        HStack {
            Text(Date.convertToKoreanDateFormat(from: taxiParty.meetingDate))
                .foregroundColor(.white)
            Rectangle().frame(width: 1, height: 12).foregroundColor(Color(red: 187 / 255, green: 187 / 255, blue: 187 / 255))
            Text("모집중")
                .foregroundColor(.customYellow)
            Spacer()
        }
    }

    var taxiPartyTime: some View {
        HStack {
            Text("\(taxiParty.readableMeetingTime)")
                .font(Font.custom("AppleSDGothicNeo-Bold", size: 50))
                .foregroundColor(.white)
            Spacer()
        }
    }

    var taxiPartyPlace: some View {
          HStack {
              Image(ImageName.taxi)
              Text(taxiParty.destinationCode == 0 ? "포항역" : "포스텍")
                      .font(Font.custom("AppleSDGothicNeo-Medium", size: 20))
                  Text("\(taxiParty.departure)")
                           .font(Font.custom("AppleSDGothicNeo-UltraLight", size: 20))
                  Image(systemName: "chevron.forward")
                      .font(.system(size: 20))
                      .padding(.horizontal, 8)
              Image(systemName: taxiParty.destinationCode == 0 ? "graduationcap.fill" : "train.side.front.car")
                      .font(.system(size: 20))
                      .foregroundColor(.darkGray)
                  Text("\(taxiParty.destination)")
                      .font(Font.custom("AppleSDGothicNeo-Medium", size: 20))
              Spacer()
          }
          .foregroundColor(.customGray)
      }

    func roundedButton(_ text: String, loading: Bool) -> some View {
        RoundedButton(text, false, loading: loading) {
            isLoading = true
            listViewModel.joinTaxiParty(in: taxiParty, userViewModel.userInfo) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    dismissWithBlurOff()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    appState.showChattingRoom(taxiParty)
                }
            }
        }
    }
}

// MARK: - 메서드

private extension TaxiPartyInfoView {

    func dismissWithBlurOff() {
        dismiss()
        showBlur = false
    }
}

// MARK: - 구조체

struct PartyMemberInfo: View {
    private let id: String
    private let diameter: CGFloat
    @StateObject private var userProfileViewModel: UserProfileViewModel = UserProfileViewModel()

    init(_ id: String, diameter: CGFloat) {
        self.id = id
        self.diameter = diameter
    }

    var body: some View {
        HStack(spacing: 20) {
            if let user = userProfileViewModel.user {
                ProfileImage(user, diameter: diameter)
                Text(user.nickname)
                    .foregroundColor(.white)
            } else {
                Circle()
                    .stroke(.white)
                    .frame(width: diameter, height: diameter)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
        }
        .onAppear {
            userProfileViewModel.getUser(id)
        }
    }
}

// MARK: - 프리뷰

struct TaxiPartyInfoView_Previews: PreviewProvider {

    static var previews: some View {
        TaxiPartyInfoView(taxiParty: TaxiParty(
            id: "121F9EBC-1607-4D23-ACCD-660DDBC3CB77",
            departureCode: 4,
            destinationCode: 1,
            meetingDate: 20220616,
            meetingTime: 1610,
            maxPersonNumber: 2,
            members: ["123456"],
            isClosed: false
        ), showBlur: .constant(false))
        .environmentObject(UserInfoState(UserInfo(id: "", nickname: "", profileImage: "")))
    }
}
