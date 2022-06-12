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
                    Spacer()
                    CurrentUserCell()
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 10, trailing: 1))
                }
                DestinationCell()
            }
            .padding()
            .frame(width: 339, height: 119)
            .background(RoundedRectangle(cornerRadius: 18.0).fill(Color(.white)))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray, lineWidth: 1.5)
                    .opacity(0.17)
                    .shadow(color: .gray, radius: 1, x: 0, y: 0)
            )
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
    }
} // 전체적인 font를 "Apple SF 산돌고딕 Neo"로 교체 예정

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
                    .frame(width: 17, height: 15)
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
            }.frame(minWidth: 90, minHeight: 20, maxHeight: 28, alignment: .center) // ex) 낙원교차로 등의 긴 문장이 와도 frame이 늘어남
                .background(RoundedRectangle(cornerRadius: 8.0).fill(Color(red: 200 / 255, green: 1 / 255, blue: 80 / 255, opacity: 0.2)))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(red: 200 / 255, green: 1 / 255, blue: 80 / 255, opacity: 1), lineWidth: 1.5)
                )
            Image("forward") // 나중에 이미지 update
                .resizable()
                .frame(width: 10, height: 15)
                .padding(.horizontal, 7)
            HStack {
                Spacer().frame(width: 10)
                Image(systemName: "tram.fill")
                    .font(.system(size: 18))
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
                Spacer().frame(width: 3)
            }.frame(minWidth: 40, minHeight: 20, maxHeight: 28, alignment: .center)
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
