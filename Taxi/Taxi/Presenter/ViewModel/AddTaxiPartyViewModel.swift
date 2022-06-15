//
//  AddTaxiPartyViewModel.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/15.
//

import Combine
import Foundation

final class AddTaxiPartyViewModel: ObservableObject {

    private var cancelBag: Set<AnyCancellable> = []
    private let addTaxiPartyUseCase: AddTaxiPartyUseCase

    init(_ addTaxiPartyUseCase: AddTaxiPartyUseCase = AddTaxiPartyUseCase()) {
        self.addTaxiPartyUseCase = addTaxiPartyUseCase
    }

    func addTaxiParty(_ taxiParty: TaxiParty, onSuccess: @escaping (TaxiParty) -> Void = { _ in }, onError: @escaping (Error) -> Void = { _ in }) {
        addTaxiPartyUseCase.addTaxiParty(taxiParty)
            .sink { completion in
                if case let .failure(error) = completion {
                    onError(error)
                }
            } receiveValue: { taxiParty in
                onSuccess(taxiParty)
            }.store(in: &cancelBag)
    }
}
