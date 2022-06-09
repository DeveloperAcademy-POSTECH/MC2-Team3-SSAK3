//
//  TaxiPartyListView.swift
//  Taxi
//
//  Created by Yosep on 2022/06/09.
//

import SwiftUI

struct TaxiPartyListView: View {
    var body: some View {
        VStack{
            HStack{
            Text("택시팟")
                .font(.title)
                .fontWeight(.bold)
                Spacer()
            Image(systemName: "plus")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.black)
            }
            Spacer(minLength: 20)
            HStack{
            Text("전체")
                    .padding(2)
            Text("포항역")
                    .padding(2)
            Text("포스텍")
                    .padding(2)
            Spacer()
            Text("날짜변경")
              .foregroundColor(.yellow)
              .fontWeight(.bold)
            }
            ScrollView{
                ForEach(0..<50) { num in
                    Text("Test: \(num)")
                }
            }
        }.padding(20)
}
}

struct TaxiPartyListView_Previews: PreviewProvider {
    static var previews: some View {
        TaxiPartyListView()
    }
}
