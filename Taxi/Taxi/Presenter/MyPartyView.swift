//
//  MyPartyView.swift
//  Taxi
//
//  Created by 이윤영 on 2022/06/12.
//

import SwiftUI

struct MyPartyView: View {
    // Dummy Data
    @State var mypartys: [TaxiParty] = [
        TaxiParty(id: "1", departureCode: 0, destinationCode: 1, meetingDate: 20220610, meetingTime: 1315, maxPersonNumber: 4, members: ["1", "2", "3", "4"], isClosed: true),
        TaxiParty(id: "2", departureCode: 0, destinationCode: 1, meetingDate: 20220611, meetingTime: 1330, maxPersonNumber: 3, members: ["1", "3"], isClosed: false),
        TaxiParty(id: "3", departureCode: 0, destinationCode: 1, meetingDate: 20220611, meetingTime: 1440, maxPersonNumber: 3, members: ["1", "2", "3"], isClosed: false),
        TaxiParty(id: "4", departureCode: 0, destinationCode: 1, meetingDate: 20220612, meetingTime: 1734, maxPersonNumber: 3, members: ["1", "2"], isClosed: false),
        TaxiParty(id: "5", departureCode: 0, destinationCode: 1, meetingDate: 20220612, meetingTime: 2005, maxPersonNumber: 2, members: ["1"], isClosed: false),
        TaxiParty(id: "6", departureCode: 0, destinationCode: 1, meetingDate: 20220617, meetingTime: 1340, maxPersonNumber: 4, members: ["1", "3"], isClosed: false)
    ]
    private var partys: [Int: [TaxiParty]] {
        Dictionary.init(grouping: mypartys, by: {$0.meetingDate})
    }
    private var meetingDates: [Int] {
        partys.map({$0.key}).sorted()
    }
    var body: some View {
        VStack {
            TitleView()
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16, pinnedViews: [.sectionHeaders]) {
                    ForEach(meetingDates, id: \.self) { date in
                        Section(header: SectionHeaderView(date: date)) {
                            ForEach(partys[date]!, id: \.id) { party in
                                NavigationLink {
                                    ChatRoomView(party: party)
                                } label: {
                                    CellView(party: party)
                                }
                                .cornerRadius(16)
                                .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.1), radius: 4, x: 0, y: 0)
                                .buttonStyle(.plain)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .background(Color.lightGray) // TODO: 색상 변경
        }
    }
}

struct TitleView: View {
    var body: some View {
        Text("마이팟")
            .foregroundColor(.customBlack)
            .font(Font.custom("AppleSDGothicNeo-Bold", size: 20))
            .fontWeight(.bold) // TODO: 텍스트 스타일로 변경
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading])
            .background(Color.white)
    }
}

struct SectionHeaderView: View {
    let date: Int
    var body: some View {
        Text("\(date / 100 % 100)월 \(date % 100)일")
            .foregroundColor(.charcoal)
            .font(Font.custom("AppleSDGothicNeo-Bold", size: 18))
            .fontWeight(.medium) // TODO: 텍스트 스타일로 변경
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .top])
            .background(Color.lightGray) // TODO: 색상 변경
    }
}

// 임시 셀뷰
// TODO: 구현될 셀뷰와 연결
struct CellView: View {
    let party: TaxiParty
    var body: some View {
        VStack {
            HStack {
                Text("\(party.meetingTime)")
                Text("\(party.members.count)/\(party.maxPersonNumber)")
            }
            HStack {
                Text("\(party.departure)")
                Text(">")
                Text("\(party.destincation)")
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
    }
}

struct MyPartyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MyPartyView()
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}
