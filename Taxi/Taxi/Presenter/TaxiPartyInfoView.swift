//
//  TaxiPartyInfoView.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/11.
//

import SwiftUI

struct TaxiPartyInfoView: View {

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image("ProfileDummy")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 80, height: 80)
                Text("Avo")
                Spacer()
            }
            HStack {
                Image("ProfileDummy")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 80, height: 80)
                Text("Avo")
                Spacer()
            }
            HStack {
                Image("ProfileDummy")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 80, height: 80)
                Text("Avo")
                Spacer()
            }
            HStack {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [10]))
                    .frame(width: 80, height: 80)
                Text("Username")
                Spacer()
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

struct TaxiPartyInfoView_Previews: PreviewProvider {

    static var previews: some View {
        TaxiPartyInfoView()
    }
}
