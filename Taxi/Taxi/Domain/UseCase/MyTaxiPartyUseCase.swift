//
//  MyTaxiPartyUseCase.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/11.
//

import Combine

final class MyTaxiPartyUseCase {
    private let myTaxiPartyRepository: MyTaxiPartyRepository

    init(_ myTaxiPartyRepository: MyTaxiPartyRepository = MyTaxiPartyFirebaseSource.shared) {
        self.myTaxiPartyRepository = myTaxiPartyRepository
    }

    func getMyTaxiParty(_ user: User, force load: Bool = false) -> AnyPublisher<[TaxiParty], Error> {
        return myTaxiPartyRepository.getMyTaxiParty(of: user, force: load)
    }

    func leaveTaxiParty(_ taxiParty: TaxiParty, user: User) -> AnyPublisher<Void, Error> {
        return myTaxiPartyRepository.leaveTaxiParty(taxiParty, user: user)
    }
}
