//
//  TaxiPartyInfoView.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/11.
//

import SwiftUI

struct TaxiPartyInfoView: View {
    let taxiParty: TaxiParty

    var body: some View {
        Text("Hello, World!")
    }
}

struct TaxiPartyInfoView_Previews: PreviewProvider {

    static var previews: some View {
        TaxiPartyInfoView(taxiParty: TaxiParty(
            id: "1",
            departureCode: 0,
            destinationCode: 1,
            meetingDate: 20220621,
            meetingTime: 1330,
            maxPersonNumber: 4,
            members: ["id1", "id2", "id3"],
            isClosed: false
        ))
    }
}
