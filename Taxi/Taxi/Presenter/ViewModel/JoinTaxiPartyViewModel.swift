//
//  JoinTaxiPartyViewModel.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/16.
//

import Foundation

final class JoinTaxiPartyViewModel: ObservableObject {
    @Published private (set) var taxiParty: TaxiParty?
    private let joinTaxiPartyUseCase: JoinTaxiPartyUseCase = JoinTaxiPartyUseCase()
    
    func joinTaxiParty(in taxiParty: TaxiParty, _ user: User) {
        joinTaxiPartyUseCase.joinTaxiParty(in: taxiParty, user) { [weak self] taxiParty, error in
            guard let self = self, let taxiParty = taxiParty else { return }
            self.taxiParty = taxiParty
        }
    }
}