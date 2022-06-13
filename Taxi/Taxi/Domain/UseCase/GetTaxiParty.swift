//
//  GetTaxiParty.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/10.
//

import Combine

final class GetTaxiPartyUseCase {
    private let taxiPartyRepository: TaxiPartyRepository
    private var cancelBag: Set<AnyCancellable> = []

    init(_ taxiPartyRepository: TaxiPartyRepository = TaxiPartyFirebaseDataSource.shared) {
        self.taxiPartyRepository = taxiPartyRepository
    }

    func getTaxiParty(exclude: String? = nil, force load: Bool = false) -> AnyPublisher<[TaxiParty], Error> {
        return taxiPartyRepository.getTaxiParty(exclude: exclude, force: load)
    }

    func getTaxiParty(exclude: String? = nil, force load: Bool = false, completion: @escaping ([TaxiParty]?, Error?) -> Void) {
        taxiPartyRepository.getTaxiParty(exclude: exclude, force: load)
            .sink { result in
                if case let .failure(error) = result {
                    completion(nil, error)
                }
            } receiveValue: { taxiParties in
                completion(taxiParties, nil)
            }.store(in: &cancelBag)
    }
}
