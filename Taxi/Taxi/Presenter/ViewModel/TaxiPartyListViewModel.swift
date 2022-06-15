//
//  TaxiPartyListViewModel.swift
//  Taxi
//
//  Created by Yosep on 2022/06/16.
//

import Foundation

final class TaxiPartyListViewModel: ObservableObject {
    @Published private (set) var taxiPartyList: [TaxiParty] = []
    private let taxiPartyListUseCase: GetTaxiPartyUseCase = GetTaxiPartyUseCase()

    func getTaxiParties(id: String?) {
        taxiPartyListUseCase.getTaxiParty(exclude: nil, force: true) { [weak self] taxiParties, error in
            guard let self = self, let taxiParties = taxiParties else {
                print(error ?? "")
                return
            }
            print("Get TaxiPartyList, taxiParties: \(taxiParties)")
            self.taxiPartyList = taxiParties
        }
    }
}
