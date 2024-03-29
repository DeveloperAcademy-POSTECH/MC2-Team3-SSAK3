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

    func joinTaxiParty(in taxiParty: TaxiParty, _ user: UserInfo) -> AnyPublisher<TaxiParty, Error> {
        return taxiPartyRepository.joinTaxiParty(in: taxiParty, user: user)
    }

    func joinTaxiParty(in taxiParty: TaxiParty, _ user: UserInfo, completion: @escaping (TaxiParty?, Error?) -> Void) {
        taxiPartyRepository.joinTaxiParty(in: taxiParty, user: user)
            .sink { result in
                if case let .failure(error) = result {
                    completion(nil, error)
                }
            } receiveValue: { taxiParty in
                completion(taxiParty, nil)
            }.store(in: &cancelBag)
    }
}
