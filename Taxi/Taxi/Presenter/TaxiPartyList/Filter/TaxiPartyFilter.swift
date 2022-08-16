//
//  TaxiPartyFilter.swift
//  Taxi
//
//  Created by JongHo Park on 2022/08/07.
//

protocol TaxiPartyFilter {
    func filter(_ taxiParties: [TaxiParty]) -> [TaxiParty]

    var filterName: String { get }
}
