//
//  CellView.swift
//  Taxi
//
//  Created by Yosep on 2022/06/09.
//
import SwiftUI

struct CellView: View {
    var body: some View {
        // Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255, opacity: 1.0)
        VStack(alignment: .leading, spacing: 13) {
            HStack {
                MeetingTimeCell()
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 130))
                CurrentUserCell()
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 1))
            }
            DestinationCell()
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        .background(RoundedRectangle(cornerRadius: 18.0).fill(Color(.white)))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray, lineWidth: 1.5)
                .opacity(0.17)
                .shadow(color: .gray, radius: 1, x: 0, y: 0)
        )
    }
}

struct MeetingTimeCell: View {
    var body: some View {
        Text("13:30")
            .font(.custom("Apple SD Gothic Neo", size: 40))
            .fontWeight(.bold) // 데이터로 처리 필요
            .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
    }
}

struct CurrentUserCell: View {
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
                .padding(EdgeInsets(top: 1, leading: 1, bottom: 4, trailing: 1))
            Text("3") // 데이터로 처리 필요
                .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
                .font(.custom("Apple SD Gothic Neo", size: 20))
            Text("/")
                .foregroundColor(Color(red: 206 / 255, green: 206 / 255, blue: 206 / 255, opacity: 1.0))
                .baselineOffset(1)
                .font(.custom("Apple SD Gothic Neo", size: 20))
            Text("4") // 데이터로 처리 필요
                .font(.custom("Apple SD Gothic Neo", size: 20))
                .foregroundColor(Color(red: 206 / 255, green: 206 / 255, blue: 206 / 255, opacity: 1.0))
        }
    }
}

struct DestinationCell: View {
    var body: some View {
        // if-else 문으로 나중에 들어오는 목적지 데이터에 따라서 포스텍<->포항역 배치 전환 해야함
        HStack {
            Spacer().frame(width: 10)
            HStack {
                Image("taxiOff")
                    .resizable()
                    .frame(width: 17, height: 16)
                    .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
                Text("포스텍")
                    .fontWeight(.medium)
                    .font(.custom("Apple SD Gothic Neo", size: 14))
                    .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
                Text("C5") // 나중에 데이터로 처리
                    .fontWeight(.thin)
                    .font(.custom("Apple SD Gothic Neo", size: 14))
                    .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
                    .padding(EdgeInsets(top: 1, leading: -5, bottom: 2, trailing: 1))
            } .padding(5)
                .background(RoundedRectangle(cornerRadius: 8.0).fill(Color(red: 200 / 255, green: 1 / 255, blue: 80 / 255, opacity: 0.2)))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(red: 200 / 255, green: 1 / 255, blue: 80 / 255, opacity: 1), lineWidth: 1.5)
                )
            Image(systemName: "chevron.forward")
                .font(.system(size: 20))
                .foregroundColor(Color(red: 160 / 255, green: 160 / 255, blue: 160 / 255, opacity: 1.0))
            HStack {
                Image(systemName: "tram.fill")
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
                Text("포항역")
                    .fontWeight(.medium)
                    .font(.custom("Apple SD Gothic Neo", size: 14))
                    .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
                Text("") // 나중에 데이터로 처리
                    .fontWeight(.thin)
                    .font(.custom("Apple SD Gothic Neo", size: 14))
                    .foregroundColor(Color(red: 64 / 255, green: 64 / 255, blue: 64 / 255, opacity: 1.0))
                    .padding(EdgeInsets(top: 1, leading: -5, bottom: 2, trailing: 1))
            }.padding(5)
                .background(RoundedRectangle(cornerRadius: 8.0).fill(Color(red: 24 / 255, green: 143 / 255, blue: 194 / 255, opacity: 0.2)))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(red: 24 / 255, green: 143 / 255, blue: 194 / 255, opacity: 1), lineWidth: 1.5))
        }
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView()
    }
}
