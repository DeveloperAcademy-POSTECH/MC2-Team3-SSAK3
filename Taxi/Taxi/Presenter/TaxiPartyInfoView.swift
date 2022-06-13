//
//  TaxiPartyInfoView.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/11.
//

import SwiftUI
import SDWebImageSwiftUI

struct TaxiPartyInfoView: View {
    @Environment(\.dismiss) private var dismiss
    let taxiParty: TaxiParty
    private let profileSize: CGFloat = 80
    private var remainSeat: Int {
        taxiParty.maxPersonNumber - taxiParty.members.count
    }

    var body: some View {
        VStack {
            dismissButton
            Spacer()
            participatingCount
            ForEach(0..<taxiParty.members.count, id: \.self) { index in
                PartyMemberInfo(id: taxiParty.members[index], diameter: profileSize)
            }
            ForEach(0..<remainSeat, id: \.self) { _ in
                emptyProfile
            }
            Divider()
            taxiPartyDate
            taxiPartyTime
            taxiPartyPlace
            RoundedButton("시작하기") {
                // TODO: Add joinTaxiParty Action
            }
        }
    }
}

extension TaxiPartyInfoView {

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
                .frame(width: 80, height: 80)
            Text("Username")
            Spacer()
        }
    }

    var taxiPartyDate: some View {
        HStack {
            Text("\(taxiParty.meetingDate / 100 % 100)월 \(taxiParty.meetingDate % 100)일")
            Text("모집중")
            Spacer()
        }
    }

    var taxiPartyTime: some View {
        HStack {
            Text("\(taxiParty.meetingTime / 100 % 100):\(taxiParty.meetingTime % 100)")
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

struct PartyMemberInfo: View {
    private let diameter: CGFloat
    private let user: User = User(
        id: "id1",
        nickname: "아보",
        profileImage: "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/f202fce4-a5b6-4e40-9f5e-f22eaf4edd87/ProfileDummy.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220611%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220611T030635Z&X-Amz-Expires=86400&X-Amz-Signature=8756de2e65dc2b6f616fb7a697bbebbaf8f779b53e3481e52fb183b4b5709821&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22ProfileDummy.png%22&x-id=GetObject"
    )

    init(id: String, diameter: CGFloat) {
        self.diameter = diameter
        // TODO: id와 유즈케이스를 통해 유저 정보 가져오고 user 변수에 넣기
    }

    var body: some View {
        HStack {
            ProfileImage(user, diameter: 80)
            Text(user.nickname)
            Spacer()
        }
    }
}

struct TaxiPartyInfoView_Previews: PreviewProvider {

    static var previews: some View {
        TaxiPartyInfoView(taxiParty: TaxiParty(
            id: "0",
            departureCode: 2,
            destinationCode: 1,
            meetingDate: 20220617,
            meetingTime: 1330,
            maxPersonNumber: 4,
            members: ["id1", "id2", "id3"],
            isClosed: false
        ))
    }
}
