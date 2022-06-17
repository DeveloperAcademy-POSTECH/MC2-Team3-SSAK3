//
//  ListViewModel.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/17.
//

import Combine

final class ListViewModel: ObservableObject {
    @Published private (set) var taxiParties: [TaxiParty] = []
    @Published private (set) var myParties: [TaxiParty] = []
    @Published private (set) var isAdding: Bool = false
    private var cancelBag: Set<AnyCancellable> = []

    // 유즈케이스
    private let getTaxiPartyUseCase: GetTaxiPartyUseCase = GetTaxiPartyUseCase()
    private let addTaxiPartyUseCase: AddTaxiPartyUseCase = AddTaxiPartyUseCase()
    private let joinTaxiPartyUseCase: JoinTaxiPartyUseCase = JoinTaxiPartyUseCase()
    private let myTaxiPartyUseCase: MyTaxiPartyUseCase = MyTaxiPartyUseCase()
    private let userId: String

    init(userId: String) {
        self.userId = userId
        getTaxiParties(force: true)
        getMyTaxiParties(force: true)
    }

    func getTaxiParties(force load: Bool = false) {
        getTaxiPartyUseCase.getTaxiParty(exclude: userId, force: load) { [weak self] taxiParties, error in
            guard let self = self, let taxiParties = taxiParties else {
                print(error ?? "")
                return
            }
            self.taxiParties = taxiParties
        }
    }

    func getMyTaxiParties(force load: Bool = false) {
        myTaxiPartyUseCase.getMyTaxiParty(userId, force: load) { [weak self] taxiParties, _ in
            guard let taxiParties = taxiParties, let self = self else {
                return
            }
            self.myParties = taxiParties
        }
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
                self.addMyTaxiPartyInList(party: taxiParty)
                onSuccess(taxiParty)
            }.store(in: &cancelBag)
    }

    func leaveMyParty(party: TaxiParty, user: User) {
        myTaxiPartyUseCase.leaveTaxiParty(party, user: user) { [weak self] error in
            guard let self = self, error == nil else {
                print(error!)
                return
            }
            self.deletePartyInList(party: party)
        }
    }

    private func deletePartyInList(party: TaxiParty) {
        if let index = self.myParties.firstIndex(of: party) {
            self.myParties.remove(at: index)
        }
    }

    private func addMyTaxiPartyInList(party: TaxiParty) {
        var copyToAdd = myParties
        copyToAdd.append(party)
        copyToAdd = copyToAdd.sorted { firstParty, secondParty in
            if firstParty.meetingDate < secondParty.meetingDate {
                return true
            } else if firstParty.meetingDate == secondParty.meetingDate {
                return firstParty.meetingTime < secondParty.meetingTime
            } else {
                return false
            }
        }
        myParties = copyToAdd
    }

    func joinTaxiParty(in taxiParty: TaxiParty, _ user: User, completion: @escaping () -> Void) {
        joinTaxiPartyUseCase.joinTaxiParty(in: taxiParty, user) { [weak self] taxiParty, _ in
            guard let self = self, let taxiParty = taxiParty else { return }
            if let index = self.taxiParties.firstIndex(of: taxiParty) {
                self.taxiParties.remove(at: index)
                self.addMyTaxiPartyInList(party: taxiParty)
                completion()
            }
        }
    }
}
