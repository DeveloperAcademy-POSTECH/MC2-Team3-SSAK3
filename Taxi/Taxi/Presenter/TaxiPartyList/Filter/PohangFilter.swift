//
//  PohangFilter.swift
//  Taxi
//
//  Created by JongHo Park on 2022/08/07.
//

struct PohangFilter: TaxiPartyFilter {

    let filterName: String = "포항역"

    func filter(_ taxiParties: [TaxiParty]) -> [TaxiParty] {

        return taxiParties.filter { taxiParty in
            taxiParty.destinationCode == Place.pohangStation.toCode()
        }
    }
}
