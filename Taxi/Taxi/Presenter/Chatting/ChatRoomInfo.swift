//
//  ChatRoomInfo.swift
//  Taxi
//
//  Created by Yosep on 2022/08/24.
//
import SwiftUI

struct ChatRoomInfo: View {
    private let taxiParty: TaxiParty
    private let profileSize: CGFloat = 62

    init(_ taxiParty: TaxiParty) {
        self.taxiParty = taxiParty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            taxiPartyDate
            taxiPartyTime
            taxiPartyPlace
            divider
                .padding(.vertical)
            participatingCount
                .padding(.bottom, 20)
            ForEach(0..<taxiParty.maxPersonNumber, id: \.self) { index in
                if index < taxiParty.currentMemeberCount {
                    PartyMemberInfo(taxiParty.members[index], diameter: profileSize)
                } else {
                    emptyProfile
                }
            }
            Spacer()
        }
        .padding([.vertical, .leading], 24)
        .background {
            Rectangle()
                .fill(Color(red: 112 / 255, green: 112 / 255, blue: 112 / 255))
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}

// MARK: - 뷰 변수

private extension ChatRoomInfo {

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
                .overlay(Image(systemName: "person.fill") .font(Font.custom("AppleSDGothicNeo-Medium", size: 30)).foregroundColor(.white))
                .background(Circle().fill(Color.gray))
            Text("모집중")
                .foregroundColor(.white)
            Spacer()
        }
    }

    var divider: some View {
        Rectangle().foregroundColor(Color.customGray).frame(height: 1)
    }

    var taxiPartyDate: some View {
        HStack {
            Text(Date.convertToKoreanDateFormat(from: taxiParty.meetingDate))
                .foregroundColor(.white)
            Rectangle().frame(width: 1, height: 12).foregroundColor(Color(red: 187 / 255, green: 187 / 255, blue: 187 / 255))
            Text(taxiParty.currentMemeberCount == taxiParty.maxPersonNumber ? "모집완료" : "모집중")
                .foregroundColor(.customYellow)
            Spacer()
        }
    }

    var taxiPartyTime: some View {
        HStack {
            Text(taxiParty.readableMeetingTime)
                .font(Font.custom("AppleSDGothicNeo-Bold", size: 50))
                .foregroundColor(.white)
            Spacer()
        }
    }

    var taxiPartyPlace: some View {
        HStack {
            Image(ImageName.taxi)
            Text("\(taxiParty.departure)")
                .font(Font.custom("AppleSDGothicNeo-Medium", size: 20))
            Image(systemName: "chevron.forward")
                .font(Font.custom("AppleSDGothicNeo-Medium", size: 20))
                .padding(.horizontal, 8)
            Image(systemName: taxiParty.destinationCode == 0 ? "graduationcap.fill" : "train.side.front.car")
                .font(.system(size: 20))
            Text("\(taxiParty.destination)")
                .font(Font.custom("AppleSDGothicNeo-Medium", size: 20))
            Spacer()
        }
        .foregroundColor(.lightGray)
    }
}

// MARK: - 구조체

struct ChatRoomMemberInfo: View {
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

struct ChatRoomInfoView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            ChatRoomInfo(TaxiParty(
                id: "121F9EBC-1607-4D23-ACCD-660DDBC3CB77",
                departureCode: 2,
                destinationCode: 1,
                meetingDate: 20220616,
                meetingTime: 610,
                maxPersonNumber: 4,
                members: ["123456"],
                isClosed: false
            ))
            .previewDisplayName("모집중인 택시팟")
            ChatRoomInfo(TaxiParty(id: "121F9EBC", departureCode: 1, destinationCode: 2, meetingDate: 20220814, meetingTime: 1620, maxPersonNumber: 4, members: ["1", "1", "1", "1"], isClosed: false))
                .previewDisplayName("모집완료된 택시팟")
        }
    }
}
