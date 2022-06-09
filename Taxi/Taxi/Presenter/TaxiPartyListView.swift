//
//  TaxiPartyListView.swift
//  Taxi
//
//  Created by Yosep on 2022/06/09.
//

import SwiftUI

struct TaxiPartyListView: View {
    var body: some View {
            ScrollView{
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
