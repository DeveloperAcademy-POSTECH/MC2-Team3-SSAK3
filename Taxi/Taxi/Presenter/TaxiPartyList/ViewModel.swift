//
//  TaxiPartyViewModel.swift
//  Taxi
//
//  Created by JongHo Park on 2022/08/07.
//

import Combine
import Foundation

// MARK: - TaxiPartyList ViewModel
extension TaxiPartyList {

    final class ViewModel: ObservableObject {
        // MARK: - States
        @Published private (set) var taxiParties: TaxiPartyState = TaxiPartyState.notRequested
        // TODO: 나중에 Calendar 를 Date 를 넘겨주도록 리팩토링해서 없애야 하는 프로퍼티임
        private (set) var taxiPartyForCalendar: [TaxiParty] = []
        private var taxiPartyFilter: TaxiPartyFilter = EmptyFilter()
        private let dateMapper: DateMapper = DateMapper()

        // MARK: - Usecase
        private let getTaxiPartyUsecase: GetTaxiPartyUsecase
        private let addTaxiPartyUsecase: AddTaxiPartyUseCase
        private let joinTaxiPartyUsecase: JoinTaxiPartyUseCase
        // MARK: - Properties
        private var cancelBag: Set<AnyCancellable> = []
        private var exclude: String?

        // MARK: - Delegates
        private weak var addTaxiPartyDelegate: AddTaxiPartyDelegete?
        private weak var joinTaxiPartyDelegate: JoinTaxiPartyDelegate?

        init(_ getTaxiPartyUsecase: GetTaxiPartyUsecase = GetTaxiPartyUsecaseImpl(),
             _ addTaxiPartyUsecase: AddTaxiPartyUseCase = AddTaxiPartyUseCase(),
             _ joinTaxiPartyUsecase: JoinTaxiPartyUseCase = JoinTaxiPartyUseCase(),
             addTaxiPartyDelegate: AddTaxiPartyDelegete? = nil,
             joinTaxiPartyDelegate: JoinTaxiPartyDelegate? = nil,
             exclude: String? = nil) {
            self.getTaxiPartyUsecase = getTaxiPartyUsecase
            self.addTaxiPartyUsecase = addTaxiPartyUsecase
            self.joinTaxiPartyUsecase = joinTaxiPartyUsecase
            self.addTaxiPartyDelegate = addTaxiPartyDelegate
            self.joinTaxiPartyDelegate = joinTaxiPartyDelegate
            self.exclude = exclude
            requestTaxiParties(force: true)
        }

        #if DEBUG
        init(_ taxiPartyState: TaxiPartyState) {
            self.taxiParties = taxiPartyState
            self.getTaxiPartyUsecase = GetTaxiPartyUsecaseImpl()
            self.addTaxiPartyUsecase = AddTaxiPartyUseCase()
            self.joinTaxiPartyUsecase = JoinTaxiPartyUseCase()
            self.exclude = nil
        }
        #endif

        func requestTaxiParties(force load: Bool = false) {
            self.taxiParties = .isLoading
            getTaxiPartyUsecase.getTaxiParty(exclude: exclude, force: load)
                .map { taxiParties in
                    self.taxiPartyFilter.filter(taxiParties)
                }
                .map { (taxiParties) -> [(key: Int, value: [TaxiParty])] in
                    self.taxiPartyForCalendar = taxiParties
                    return self.dateMapper.mapping(taxiParties)
                }
                .sink { [weak self] completion in
                    guard let self = self else { return }
                    switch completion {
                    case .failure(let error):
                        self.taxiParties = .error(error: error)
                    case .finished:
                        break
                    }
                } receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    guard !value.isEmpty else {
                        self.taxiParties = .empty
                        return
                    }
                    self.taxiParties = .loaded(value)
                }.store(in: &cancelBag)
        }

        func changeFilter(_ taxiPartyFilter: TaxiPartyFilter) {
            self.taxiPartyFilter = taxiPartyFilter
            requestTaxiParties(force: false)
        }

        func addTaxiParty(_ taxiParty: TaxiParty, user: UserInfo, onSuccess: @escaping (TaxiParty) -> Void = { _ in }, onError: @escaping (Error) -> Void = { _ in }) {
            addTaxiPartyUsecase.addTaxiParty(taxiParty, user: user)
                .sink { completion in
                    if case let .failure(error) = completion {
                        onError(error)
                    }
                } receiveValue: { [weak self] taxiParty in
                    self?.requestTaxiParties(force: true)
                    self?.addTaxiPartyDelegate?.addTaxiParty(taxiParty)
                    onSuccess(taxiParty)
                }.store(in: &cancelBag)
        }

        func joinTaxiParty(in taxiParty: TaxiParty, _ user: UserInfo, completion: @escaping () -> Void, onError: @escaping (Error) -> Void = { _ in }) {
            joinTaxiPartyUsecase.joinTaxiParty(in: taxiParty, user) { [weak self] taxiParty, error in
                guard let self = self, let taxiParty = taxiParty else {
                    if let error = error {
                        onError(error)
                    }
                    return
                }
                completion()
                self.joinTaxiPartyDelegate?.joinTaxiParty(taxiParty)
                self.requestTaxiParties(force: true)
            }
        }
    }
}
