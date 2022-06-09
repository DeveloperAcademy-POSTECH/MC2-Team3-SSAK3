//
//  TaxiPartyListView.swift
//  Taxi
//
//  Created by Yosep on 2022/06/09.
//

import SwiftUI

struct TaxiPartyListView: View {
    var body: some View {
        VStack {
            TaxiPartyHeadLine()
            Spacer(minLength: 20)
            HStack {
                TaxiPartyFiltering()
                Spacer()
                MeetingDateChange()
            }
            Spacer(minLength: 20)
            CellViewList()
        }.padding(20)
    }
}

struct TaxiPartyHeadLine: View {
    var body: some View {
        HStack {
            Text("택시팟")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            Button {
                print("+ tapped!")
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.black)
            }
        }
    }
}

struct TaxiPartyFiltering: View {
    @State var destinations: [String] = ["전체", "포항역", "포스텍"]
    var body: some View {
        HStack {
            ForEach(destinations, id: \.self) { name in
                Button {
                    print("filter tapped!")
                } label: {
                    Text(name)
                        .padding(5)
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct MeetingDateChange: View {
    var body: some View {
        Button {
            print("날짜변경 tapped!")
        } label: {
            Text("날짜 변경")
                .foregroundColor(Color(red: 255 / 255, green: 214 / 255, blue: 0 / 255, opacity: 1.0))
                .fontWeight(.bold)
        }
    }
}

struct CellViewList: View {
    var body: some View {
        ScrollView {
            ForEach(0..<50) { num in
                Text("Test: \(num)")
            }
        }
    }
}

struct TaxiPartyListView_Previews: PreviewProvider {
    static var previews: some View {
        TaxiPartyListView()
    }
}
