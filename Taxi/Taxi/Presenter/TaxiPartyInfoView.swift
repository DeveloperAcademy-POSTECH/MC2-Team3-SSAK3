//
//  TaxiPartyInfoView.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/11.
//

import SwiftUI

struct TaxiPartyInfoView: View {
    @Binding var taxiParty: TaxiParty

    var body: some View {
        Text("Hello, World!")
    }
}

struct TaxiPartyInfoView_Previews: PreviewProvider {
    @State static var taxiParty: TaxiParty = TaxiParty(
        id: "1",
        departureCode: 0,
        destinationCode: 1,
        meetingDate: 20220621,
        meetingTime: 1330,
        maxPersonNumber: 4,
        members: ["아보", "호종", "요셉"],
        isClosed: false
    )

    static var previews: some View {
        TaxiPartyInfoView(taxiParty: $taxiParty)
    }
}
