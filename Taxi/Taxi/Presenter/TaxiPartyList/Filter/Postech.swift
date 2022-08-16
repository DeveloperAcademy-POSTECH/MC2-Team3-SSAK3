//
//  C5Filter.swift
//  Taxi
//
//  Created by JongHo Park on 2022/08/07.
//

struct PostechFilter: TaxiPartyFilter {

    let filterName: String = "포스텍"

    func filter(_ taxiParties: [TaxiParty]) -> [TaxiParty] {
        return taxiParties.filter { taxiParty in
            taxiParty.destinationCode == Place.postech.toCode()
        }
    }
}
