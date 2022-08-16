//
//  EmptyFilter.swift
//  Taxi
//
//  Created by JongHo Park on 2022/08/07.
//

struct EmptyFilter: TaxiPartyFilter {

    let filterName: String = "전체"

    func filter(_ taxiParties: [TaxiParty]) -> [TaxiParty] {
        return taxiParties
    }
}
