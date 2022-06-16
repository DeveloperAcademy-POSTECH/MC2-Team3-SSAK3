//
//  JoinTaxiParty.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/10.
//

import Combine

final class JoinTaxiPartyUseCase {
    private let taxiPartyRepository: TaxiPartyRepository
    private var cancelBag: Set<AnyCancellable> = []

    init(_ taxiPartyRepository: TaxiPartyRepository = TaxiPartyFirebaseDataSource.shared) {
        self.taxiPartyRepository = taxiPartyRepository
    }

    func joinTaxiParty(in taxiParty: TaxiParty, _ user: User) -> AnyPublisher<TaxiParty, Error> {
        return taxiPartyRepository.joinTaxiParty(in: taxiParty, id: user.id)
    }

    func joinTaxiParty(in taxiParty: TaxiParty, _ user: User, completion: @escaping (TaxiParty?, Error?) -> Void) {
        taxiPartyRepository.joinTaxiParty(in: taxiParty, id: user.id)
            .sink { result in
                if case let .failure(error) = result {
                    completion(nil, error)
                }
            } receiveValue: { taxiParty in
                completion(taxiParty, nil)
            }.store(in: &cancelBag)
    }
}
