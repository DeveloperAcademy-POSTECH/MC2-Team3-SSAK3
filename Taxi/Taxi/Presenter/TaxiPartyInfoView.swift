//
//  TaxiPartyInfoView.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/11.
//

import SwiftUI

struct TaxiPartyInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userViewModel: Authentication
    @StateObject private var joinTaxiPartyViewModel: JoinTaxiPartyViewModel = JoinTaxiPartyViewModel()
    let taxiParty: TaxiParty
    private let profileSize: CGFloat = 80
    private var remainSeat: Int { taxiParty.maxPersonNumber - taxiParty.members.count }
    private var meetingMonth: Int { taxiParty.meetingDate / 100 % 100 }
    private var meetingDay: Int { taxiParty.meetingDate % 100 }
    private var meetingHour: String { String(format: "%02d", taxiParty.meetingTime / 100 % 100) }
    private var meetingMinute: String { String(format: "%02d", taxiParty.meetingTime % 100) }

    var body: some View {
        VStack {
            dismissButton
            Spacer()
            participatingCount
            ForEach(0..<taxiParty.members.count, id: \.self) { index in
                PartyMemberInfo(taxiParty.members[index], diameter: profileSize)
            }
            ForEach(0..<remainSeat, id: \.self) { _ in
                emptyProfile
            }
            Divider()
            taxiPartyDate
            taxiPartyTime
            taxiPartyPlace
            RoundedButton("시작하기") {
                if let user = userViewModel.user {
                    joinTaxiPartyViewModel.joinTaxiParty(in: taxiParty, user)
                }
                // TODO: Move to chatroom
            }
        }
    }
}

// MARK: - 뷰 변수

private extension TaxiPartyInfoView {

    var dismissButton: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
            }
            Spacer()
        }
    }

    var participatingCount: some View {
        HStack {
            Text("참여중인 멤버")
            Image(systemName: "person.fill")
            Text("\(taxiParty.members.count)/\(taxiParty.maxPersonNumber)")
            Spacer()
        }
    }

    var emptyProfile: some View {
        HStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [10]))
                .frame(width: profileSize, height: profileSize)
            Text("Username")
            Spacer()
        }
    }

    var taxiPartyDate: some View {
        HStack {
            Text("\(meetingMonth)월 \(meetingDay)일")
            Text("모집중")
            Spacer()
        }
    }

    var taxiPartyTime: some View {
        HStack {
            Text("\(meetingHour):\(meetingMinute)")
            Spacer()
        }
    }

    var taxiPartyPlace: some View {
        HStack {
            Image(ImageName.taxi)
            switch taxiParty.destinationCode {
            case 0:
                Text("포항역")
            case 1:
                Text("포스텍")
            default:
                fatalError()
            }
            Text("\(taxiParty.departure)")
            Image(systemName: "chevron.forward")
            Image(ImageName.train)
            Text("\(taxiParty.destincation)")
        }
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
        HStack {
            if let user = userProfileViewModel.user {
                ProfileImage(user, diameter: diameter)
                Text(user.nickname)
            } else {
                HStack {
                    Circle().foregroundColor(.lightGray).frame(width: diameter, height: diameter)
                    Rectangle().foregroundColor(.lightGray).frame(width: 80, height: 20)
                    Spacer()
                }
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
            departureCode: 2,
            destinationCode: 1,
            meetingDate: 20220616,
            meetingTime: 1610,
            maxPersonNumber: 2,
            members: ["123456"],
            isClosed: false
        ))
        .environmentObject(Authentication())
    }
}
