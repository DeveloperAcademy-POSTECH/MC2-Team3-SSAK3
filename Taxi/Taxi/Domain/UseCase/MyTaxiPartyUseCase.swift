//
//  MyTaxiPartyUseCase.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/11.
//

import Combine

final class MyTaxiPartyUseCase {
    private let myTaxiPartyRepository: MyTaxiPartyRepository
    private var cancelBag: Set<AnyCancellable> = []

    init(_ myTaxiPartyRepository: MyTaxiPartyRepository = MyTaxiPartyFirebaseSource.shared) {
        self.myTaxiPartyRepository = myTaxiPartyRepository
    }

    func getMyTaxiParty(_ userId: String, force load: Bool = false) -> AnyPublisher<[TaxiParty], Error> {
        return myTaxiPartyRepository.getMyTaxiParty(of: userId, force: load)
    }

    func leaveTaxiParty(_ taxiParty: TaxiParty, user: User) -> AnyPublisher<Void, Error> {
        return myTaxiPartyRepository.leaveTaxiParty(taxiParty, user: user)
    }

    func getMyTaxiParty(_ userId: String, force load: Bool = false, completion: @escaping ([TaxiParty]?, Error?) -> Void) {
        myTaxiPartyRepository.getMyTaxiParty(of: userId, force: load)
            .sink { result in
                if case let .failure(error) = result {
                    completion(nil, error)
                }
            } receiveValue: { taxiParties in
                completion(taxiParties, nil)
            }.store(in: &cancelBag)
    }

    func leaveTaxiParty(_ taxiParty: TaxiParty, user: User, completion: @escaping (Error?) -> Void) {
        myTaxiPartyRepository.leaveTaxiParty(taxiParty, user: user)
            .sink { result in
                switch result {
                case .failure(let error):
                    completion(error)
                case .finished:
                    completion(nil)
                }
            } receiveValue: { _ in }
            .store(in: &cancelBag)
    }
}
