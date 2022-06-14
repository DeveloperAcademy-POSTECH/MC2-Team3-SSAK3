//
//  AddTaxiParty.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/10.
//
import Combine

final class AddTaxiPartyUseCase {
    private let taxiPartyRepository: TaxiPartyRepository
    private var cancelBag: Set<AnyCancellable> = []

    init(taxiPartyRepository: TaxiPartyRepository = TaxiPartyFirebaseDataSource.shared) {
        self.taxiPartyRepository = taxiPartyRepository
    }

    func addTaxiParty(_ taxiParty: TaxiParty) -> AnyPublisher<TaxiParty, Error> {
        return taxiPartyRepository.addTaxiParty(taxiParty)
    }

    func addTaxiParty(_ taxiParty: TaxiParty, completion: @escaping (TaxiParty?, Error?) -> Void) {
        taxiPartyRepository.addTaxiParty(taxiParty)
            .sink { result in
                if case let .failure(error) = result {
                    completion(nil, error)
                }
            } receiveValue: { taxiParty in
                completion(taxiParty, nil)
            }.store(in: &cancelBag)
    }
}
