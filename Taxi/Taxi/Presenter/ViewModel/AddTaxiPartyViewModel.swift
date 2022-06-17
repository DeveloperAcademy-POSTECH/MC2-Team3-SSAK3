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
    @Published private (set) var isAdding: Bool = false

    init(_ addTaxiPartyUseCase: AddTaxiPartyUseCase = AddTaxiPartyUseCase()) {
        self.addTaxiPartyUseCase = addTaxiPartyUseCase
    }

    func addTaxiParty(_ taxiParty: TaxiParty, user: User, onSuccess: @escaping (TaxiParty) -> Void = { _ in }, onError: @escaping (Error) -> Void = { _ in }) {
        isAdding = true
        addTaxiPartyUseCase.addTaxiParty(taxiParty, user: user)
            .sink { [weak self] completion in
                guard let self = self else {
                    return
                }
                if case let .failure(error) = completion {
                    onError(error)
                }
                self.isAdding = false
            } receiveValue: { taxiParty in
                onSuccess(taxiParty)
            }.store(in: &cancelBag)
    }
}
