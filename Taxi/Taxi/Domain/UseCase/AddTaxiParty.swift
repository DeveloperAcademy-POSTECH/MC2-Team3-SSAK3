//
//  AddTaxiParty.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/10.
//
import Combine

final class AddTaxiPartyUseCase {
    private let taxiPartyRepository: TaxiPartyRepository

    init(taxiPartyRepository: TaxiPartyRepository = TaxiPartyFirebaseDataSource.shared) {
        self.taxiPartyRepository = taxiPartyRepository
    }

    func addTaxiParty(_ taxiParty: TaxiParty) -> AnyPublisher<TaxiParty, Error> {
        return taxiPartyRepository.addTaxiParty(taxiParty)
    }
}
