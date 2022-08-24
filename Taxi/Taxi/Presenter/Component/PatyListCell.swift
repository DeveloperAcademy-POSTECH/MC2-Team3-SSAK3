//
//  CellView.swift
//  Taxi
//
//  Created by Yosep on 2022/06/09.
//
import SwiftUI

struct PartyListCell: View {
    let party: TaxiParty

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DestinationView(party: party)
            HStack(alignment: .top, spacing: 0) {
                MeetTimeView(meetingTime: party.readableMeetingTime)
                Spacer()
                DepartureView(party: party)
                Spacer()
                UserView(party: party)
            }
            .padding(.vertical, 7)
            .padding(.horizontal, 7)
        }
        .padding()
    }
}

struct DestinationView: View {
    let party: TaxiParty

    var body: some View {
        if party.destinationCode == 0 {
            cellHeader(image: "graduationcap.fill", color: Color.postechPink)
        } else {
            cellHeader(image: "train.side.front.car", color: Color.ktxBlue)
        }
    }

    private func cellHeader(image: String, color: Color) -> some View {
        HStack(spacing: 2) {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 17, height: 18)
                .foregroundColor(color)
            Text("\(party.destination)으로")
                .font(.custom("AppleSDGothicNeo-Medium", size: 14))
                .foregroundColor(color)
        }
    }
}

struct MeetTimeView: View {
    let meetingTime: String

    var body: some View {
        VStack {
            Text(meetingTime)
                .font(.custom("AppleSDGothicNeo-Bold", size: 28))
                .foregroundColor(Color.customBlack)
                .padding(0)
            Text("모임시간")
                .font(.custom("AppleSDGothicNeo-Regular", size: 12))
                .foregroundColor(Color.darkGray)
        }
    }
}

struct DepartureView: View {
    let party: TaxiParty

    var body: some View {
        if party.destinationCode == 0 {
            departureinfo(departure: "포항역")
        } else {
            departureinfo(departure: "포스텍")
        }
    }
    private func departureinfo(departure: String) -> some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 5) {
                Text(departure)
                    .font(.custom("AppleSDGothicNeo-Medium", size: 20))
                    .foregroundColor(Color.customBlack)
                Text("\(party.departure)")
                    .font(.custom("AppleSDGothicNeo-Light", size: 18))
                    .foregroundColor(Color.customBlack)
            }
            .padding(5)
            Text("모임장소")
                .font(.custom("AppleSDGothicNeo-Regular", size: 12))
                .foregroundColor(Color.darkGray)
        }
    }
}

struct UserView: View {
    let party: TaxiParty

    var body: some View {
        HStack(alignment: .top, spacing: 2) {
            Image(systemName: "person.fill")
                .font(.system(size: 15))
                .foregroundColor(Color.charcoal)
            HStack(alignment: .center, spacing: 2) {
                Text("\(party.members.count)") // 데이터로 처리 필요
                    .font(.custom("AppleSDGothicNeo-Regular", size: 16))
                    .foregroundColor(Color.customBlack)
                Text("/")
                    .font(.custom("AppleSDGothicNeo-Regular", size: 12))
                    .foregroundColor(Color.darkGray)
                Text("\(party.maxPersonNumber)") // 데이터로 처리 필요
                    .font(.custom("AppleSDGothicNeo-Regular", size: 16))
                    .foregroundColor(Color.darkGray)
            }
        }
        .padding(.vertical, 7)
    }
}

struct CellBackground: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .background(.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.06), radius: 15, x: 1, y: 2)
    }
}

extension View {
    func cellBackground() -> some View {
        modifier(CellBackground())
    }
}

#if DEBUG
struct PatyListCell_Previews: PreviewProvider {
    static var previews: some View {
        PartyListCell(party: TaxiPartyMockData.mockData.first!)
            .environmentObject(MyPartyView.ViewModel(userId: ""))
            .previewLayout(.sizeThatFits)
    }
}
#endif
