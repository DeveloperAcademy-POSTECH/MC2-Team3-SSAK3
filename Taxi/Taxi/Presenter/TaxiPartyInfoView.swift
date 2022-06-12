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

    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                Spacer()
            }
            Spacer()
            Group {
                PartyMemberInfo(id: taxiParty.members[0], diameter: 80)
                PartyMemberInfo(id: taxiParty.members[1], diameter: 80)
                PartyMemberInfo(id: taxiParty.members[2], diameter: 80)
                HStack {
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [10]))
                        .frame(width: 80, height: 80)
                    Text("Username")
                    Spacer()
                }
            }
            Divider()
            HStack {
                Text("6월 17일 금요일")
                Text("모집중")
                Spacer()
            }
            HStack {
                Text("13:30")
                Spacer()
                Text("3/4")
                Image(systemName: "person.fill")
            }
            HStack {
                Image(ImageName.tabTaxiPartyOff)
                Text("포스텍 C5")
                Image(systemName: "tram.fill")
                Text("포항역")
            }
            RoundedButton("시작하기") {
                // TODO: Add joinTaxiParty Action
            }
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
            if let imageURL = user.profileImage {
                WebImage(url: URL(string: imageURL))
                    .profileCircle(diameter)
            } else {
                ZStack {
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: diameter, height: diameter)
                    Text(user.nickname.prefix(1))
                        .foregroundColor(.black)
                }
            }
            Text(user.nickname)
            Spacer()
        }
    }
}

struct TaxiPartyInfoView_Previews: PreviewProvider {

    static var previews: some View {
        TaxiPartyInfoView(taxiParty: TaxiParty(
            id: "0",
            departureCode: 0,
            destinationCode: 1,
            meetingDate: 20220617,
            meetingTime: 1330,
            maxPersonNumber: 4,
            members: ["id1", "id2", "id3"],
            isClosed: false
        ))
    }
}
