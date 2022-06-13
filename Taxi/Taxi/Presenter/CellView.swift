//
//  CellView.swift
//  Taxi
//
//  Created by Yosep on 2022/06/09.
//
import SwiftUI

struct CellView: View {
    let party: TaxiParty
    private let paddingSize: CGFloat = 6
    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack {
                MeetTimeView(party: party)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
                    Text("\(party.members.count)") // 데이터로 처리 필요
                        .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
                        .font(.custom("Apple SD Gothic Neo", size: 20))
                    Text("/")
                        .foregroundColor(Color(red: 206 / 255, green: 206 / 255, blue: 206 / 255, opacity: 1.0))
                        .font(.custom("Apple SD Gothic Neo", size: 20))
                    Text("\(party.maxPersonNumber)") // 데이터로 처리 필요
                        .foregroundColor(Color(red: 206 / 255, green: 206 / 255, blue: 206 / 255, opacity: 1.0))
                        .font(.custom("Apple SD Gothic Neo", size: 20))
                }
            }
            HStack {
                HStack {
                    Image("taxiOff")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 17, height: 18)
                        .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
                    Text("\(party.departure)")
                        .fontWeight(.medium)
                        .font(.custom("Apple SD Gothic Neo", size: 14))
                        .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
                    Text("C5") // 나중에 데이터로 처리
                        .fontWeight(.thin)
                        .font(.custom("Apple SD Gothic Neo", size: 14))
                        .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
                } .padding(paddingSize)
                    .background {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(red: 200 / 255, green: 1 / 255, blue: 80 / 255, opacity: 0.2))
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(red: 200 / 255, green: 1 / 255, blue: 80 / 255, opacity: 1), lineWidth: 1.5)
                                .opacity(1)
                        }
                    }
                Image(systemName: "chevron.forward")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 160 / 255, green: 160 / 255, blue: 160 / 255, opacity: 1.0))
                HStack {
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
                }.padding(paddingSize)
                    .background {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(red: 24 / 255, green: 143 / 255, blue: 194 / 255, opacity: 0.2))
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(red: 24 / 255, green: 143 / 255, blue: 194 / 255, opacity: 1), lineWidth: 1.5)
                                .opacity(1)
                        }
                    }
            }
        }
        .padding(18)
        .background {
            ZStack { // Struct로 만들어서 표현하자
                RoundedRectangle(cornerRadius: 18.0)
                    .fill(Color(.white))
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(red: 240 / 255, green: 240 / 255, blue: 240 / 255, opacity: 1.0), lineWidth: 1.5)
            }
        }
        .padding(.horizontal)
    }
}

struct MeetTimeView: View {
    let party: TaxiParty
    func meetTimeSeparator(str1: String) -> String {
        var meet: String = str1
        let index1 = meet.index(meet.startIndex, offsetBy: 2)
        meet.insert(":", at: index1)
        return "\(meet)"
    }
    var body: some View {
        Text("\(meetTimeSeparator(str1: String(party.meetingTime)))")
            .font(.custom("Apple SD Gothic Neo", size: 40))
            .fontWeight(.bold) // 데이터로 처리 필요
            .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        TaxiPartyListView()
    }
}
