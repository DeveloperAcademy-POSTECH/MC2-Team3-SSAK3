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
            Text("Test")
                .font(.title)
                .fontWeight(.bold)
                Spacer()
            Image(systemName: "plus")
            .foregroundColor(.black)
            }
            Spacer()
            HStack{
            Text("Test")
            Text("Test")
            Text("Test")
                Spacer()
            Text("Test")
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
