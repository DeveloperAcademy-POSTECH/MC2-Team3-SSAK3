//
//  CellView.swift
//  Taxi
//
//  Created by Yosep on 2022/06/09.
//
import SwiftUI

struct PatyListCell: View {
    let party: TaxiParty

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DestinationView(party: party)
            HStack(alignment: .top, spacing: 0) {
                MeetTimeView(meetingTime: party.meetingTime)
                Spacer()
                DepartureView(party: party)
                Spacer()
                UserView(party: party)
            } .padding(.vertical, 8)
                .padding(.horizontal, 18)
        }
        .padding()
        .background {
            ZStack {
                if party.departureCode == 1 {
                    RoundedRectangle(cornerRadius: 18.0)
                        .fill(Color.postechPink.opacity(0.05))
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.postechPink.opacity(1.0), lineWidth: 1.5)
                } else {
                    RoundedRectangle(cornerRadius: 18.0)
                        .fill(Color.ktxBlue.opacity(0.05))
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.ktxBlue.opacity(1.0), lineWidth: 1.5)
                }
            }
        }.padding(.horizontal)
    }
}

struct DestinationView: View {
    let party: TaxiParty

    var body: some View {
        if party.departureCode == 1 {
            HStack(alignment: .center, spacing: 2) {
                Image(systemName: "graduationcap.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 17, height: 18)
                    .foregroundColor(Color.postechPink)
                Text("\(party.destincation)으로")
                    .font(.custom("AppleSDGothicNeo-Medium", size: 14))
                    .foregroundColor(Color.postechPink)
                Text("") // 나중에 데이터로 처리
                    .fontWeight(.thin)
                    .font(.custom("AppleSDGothicNeo-Regular", size: 14))
                    .foregroundColor(Color.postechPink)
            }
        } else {
            HStack(alignment: .center, spacing: 2) {
                Image(systemName: "train.side.front.car")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 17, height: 18)
                    .foregroundColor(Color.ktxBlue)
                Text("\(party.destincation)으로")
                    .font(.custom("AppleSDGothicNeo-Medium", size: 14))
                    .foregroundColor(Color.ktxBlue)
                Text("") // 나중에 데이터로 처리
                    .fontWeight(.thin)
                    .font(.custom("AppleSDGothicNeo-Regular", size: 14))
                    .foregroundColor(Color.ktxBlue)
            }
        }
    }
}

struct MeetTimeView: View {
    let meetingTime: Int

    var body: some View {
        VStack {
            Text("\(meetTimeSeparator(meetTime: String(meetingTime)))")
            // Text("\(party.meetingTime / 100 % 100 ):\(party.meetingTime % 100)") --> 00분일 때 0하나 짤림
                .font(.custom("AppleSDGothicNeo-Bold", size: 28))
                .foregroundColor(Color.customBlack)
                .padding(0)
            Text("모임시간")
                .font(.custom("AppleSDGothicNeo-Regular", size: 12))
                .foregroundColor(Color.darkGray)
        }
    }

    func meetTimeSeparator(meetTime: String) -> String {
        var meet: String = meetTime
        let crashBlock = -2
        if crashBlock == -2 {
            let index1 = meet.index(meet.endIndex, offsetBy: crashBlock)
            meet.insert(":", at: index1)
        }
        return "\(meet)"
    }
}

struct DepartureView: View {
    let party: TaxiParty

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .bottom, spacing: 5) {
                Text("\(party.departure)")
                    .font(.custom("AppleSDGothicNeo-Medium", size: 20))
                    .foregroundColor(Color.customBlack)
                Text("C5") // 나중에 데이터로 처리
                    .fontWeight(.ultraLight)
                    .font(.custom("AppleSDGothicNeo-Regular", size: 20))
                    .foregroundColor(Color.customBlack)
            }.padding(5)
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
                    .foregroundColor(Color.customGray)
                Text("\(party.maxPersonNumber)") // 데이터로 처리 필요
                    .font(.custom("AppleSDGothicNeo-Regular", size: 16))
                    .foregroundColor(Color.customGray)
            }
        }.padding(.vertical, 7)
    }
}

struct PatyListCell_Previews: PreviewProvider {
    static var previews: some View {
        TaxiPartyListView()
    }
}
