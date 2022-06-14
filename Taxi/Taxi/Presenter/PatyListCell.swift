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
            HStack(alignment: .top, spacing: 0)  {
                MeetTimeView(meetingTime: party.meetingTime)
                Spacer()
                DepartureView(party: party)
                Spacer()
                UserView(party: party)
            } .padding(.vertical, 14)
                .padding(.horizontal, 18)
        }
        .padding()
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 18.0)
                    .fill(Color(.white))
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.darkGray.opacity(1.0), lineWidth: 1.5)
            }
        }.padding(.horizontal)
    }
}

struct DestinationView: View {
    let party: TaxiParty

    var body: some View {
        HStack(alignment: .center, spacing: 2) {
            Image(systemName: "tram.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 17, height: 18)
                .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
            Text("\(party.destincation)")
                .fontWeight(.medium)
                .font(.custom("Apple SD Gothic Neo", size: 14))
                .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
            Text("") // 나중에 데이터로 처리
                .fontWeight(.thin)
                .font(.custom("Apple SD Gothic Neo", size: 14))
                .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
        }
    }
}

struct MeetTimeView: View {
    let meetingTime: Int

    var body: some View {
        VStack {
            Text("\(meetTimeSeparator(meetTime: String(meetingTime)))")
            // Text("\(party.meetingTime / 100 % 100 ):\(party.meetingTime % 100)") --> 00분일 때 0하나 짤림
                .font(.custom("Apple SD Gothic Neo", size: 28))
                .fontWeight(.bold) // 데이터로 처리 필요
                .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
                .padding(0)
            Text("모임시간")
                .font(.custom("Apple SD Gothic Neo", size: 12))
        }
    }

    func meetTimeSeparator(meetTime: String) -> String {
        var meet: String = meetTime
        let index1 = meet.index(meet.endIndex, offsetBy: -2) // TODO: offsetBy부분 if문으로 처리하여 app crash 방지
        meet.insert(":", at: index1)
        return "\(meet)"
    }
}

struct DepartureView: View {
    let party: TaxiParty

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .bottom, spacing: 5) {
                Text("\(party.departure)")
                    .fontWeight(.medium)
                    .font(.custom("Apple SD Gothic Neo", size: 20))
                    .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
                Text("C5") // 나중에 데이터로 처리
                    .fontWeight(.thin)
                    .font(.custom("Apple SD Gothic Neo", size: 20))
                    .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
            }.padding(5)
            Text("모임시간")
                .font(.custom("Apple SD Gothic Neo", size: 12))

        }
    }
}

struct UserView: View {
    let party: TaxiParty

    var body: some View {
        HStack(alignment: .top, spacing: 2) {
            Image(systemName: "person.fill")
                .font(.system(size: 15))
                .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
            HStack(alignment: .center, spacing: 2) {
                Text("\(party.members.count)") // 데이터로 처리 필요
                    .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
                    .font(.custom("Apple SD Gothic Neo", size: 16))
                Text("/")
                    .foregroundColor(Color(red: 206 / 255, green: 206 / 255, blue: 206 / 255, opacity: 1.0))
                    .font(.custom("Apple SD Gothic Neo", size: 12))
                Text("\(party.maxPersonNumber)") // 데이터로 처리 필요
                    .foregroundColor(Color(red: 206 / 255, green: 206 / 255, blue: 206 / 255, opacity: 1.0))
                    .font(.custom("Apple SD Gothic Neo", size: 16))
            }
        }.padding(.vertical, 7)
    }
}

struct PatyListCell_Previews: PreviewProvider {
    static var previews: some View {
        TaxiPartyListView()
    }
}
