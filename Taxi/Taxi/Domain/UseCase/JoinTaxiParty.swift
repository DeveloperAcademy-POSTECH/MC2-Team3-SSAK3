//
//  JoinTaxiParty.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/10.
//

import Combine

final class JoinTaxiPartyUseCase {
    private let taxiPartyRepository: TaxiPartyRepository

    init(_ taxiPartyRepository: TaxiPartyRepository = TaxiPartyFirebaseDataSource.shared) {
        self.taxiPartyRepository = taxiPartyRepository
    }

    func joinTaxiParty(in taxiParty: TaxiParty, _ user: User) -> AnyPublisher<TaxiParty, Error> {
        return taxiPartyRepository.joinTaxiParty(to: taxiParty)
    }
}
