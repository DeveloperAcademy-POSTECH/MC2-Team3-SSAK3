//
//  GetTaxiParty.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/10.
//

import Combine

final class GetTaxiPartyUseCase {
    private let taxiPartyRepository: TaxiPartyRepository

    init(_ taxiPartyRepository: TaxiPartyRepository = TaxiPartyFirebaseDataSource.shared) {
        self.taxiPartyRepository = taxiPartyRepository
    }

    func getTaxiParty(exclude: String? = nil, force load: Bool = false) -> AnyPublisher<[TaxiParty], Error> {
        return taxiPartyRepository.getTaxiParty(exclude: exclude, force: load)
    }
}
