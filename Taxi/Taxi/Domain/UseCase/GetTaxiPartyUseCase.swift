//
//  GetTaxiParty.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/10.
//

import Combine

protocol GetTaxiPartyUsecase {
    func getTaxiParty(exclude: String?, force load: Bool) -> AnyPublisher<[TaxiParty], Error>
}

final class GetTaxiPartyUsecaseImpl: GetTaxiPartyUsecase {
    private let taxiPartyRepository: TaxiPartyRepository

    init(_ taxiPartyRepository: TaxiPartyRepository = TaxiPartyFirebaseDataSource.shared) {
        self.taxiPartyRepository = taxiPartyRepository
    }

    func getTaxiParty(exclude: String? = nil, force load: Bool = false) -> AnyPublisher<[TaxiParty], Error> {
        return taxiPartyRepository.getTaxiParty(exclude: exclude, force: load)
    }
}
