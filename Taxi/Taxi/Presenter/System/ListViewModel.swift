//
//  ListViewModel.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/17.
//

import Combine
import Foundation
enum ListError: LocalizedError {
    case outOfMember
    case loadPartiesFail
    case addPartyFail
    case leavePartyFail
    case noTaxiParties
    case noMyParties

    var errorDescription: String? {
        switch self {
        case .outOfMember:
            return "이미 마감된 택시팟이에요"
        case .loadPartiesFail:
            return "택시팟을 불러올 수 없어요"
        case .addPartyFail:
            return "택시팟을 추가할 수 없어요"
        case .leavePartyFail:
            return "택시팟을 나갈 수 없어요"
        case .noTaxiParties:
            return "현재 생성된 택시팟이 없어요"
        case .noMyParties:
            return "현재 참여하고 있는 택시팟이 없어요"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .outOfMember:
            return "현재 인원이 모두 찼어요\n다른 택시팟을 찾아보시겠어요?"
        case .loadPartiesFail, .addPartyFail, .leavePartyFail:
            return "잠시 후 다시 시도해보세요"
        case .noTaxiParties:
            return "택시팟을 만들어보세요"
        case .noMyParties:
            return ""
        }
    }
}

final class ListViewModel: ObservableObject {
    @Published private (set) var taxiParties: [TaxiParty] = []
    @Published private (set) var myParties: [TaxiParty] = []
    @Published private (set) var isAdding: Bool = false
    @Published var error: ListError?
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
                self?.error = .loadPartiesFail
                return
            }
            self.taxiParties = taxiParties
            if self.error == .loadPartiesFail {
                self.error = nil
            }
        }
    }

    func getMyTaxiParties(force load: Bool = false) {
        myTaxiPartyUseCase.getMyTaxiParty(userId, force: load) { [weak self] taxiParties, _ in
            guard let taxiParties = taxiParties, let self = self else {
                self?.error = .loadPartiesFail
                return
            }
            self.myParties = taxiParties
            if self.error == .loadPartiesFail {
                self.error = nil
            }
        }
    }

    func addTaxiParty(_ taxiParty: TaxiParty, user: UserInfo, onSuccess: @escaping (TaxiParty) -> Void = { _ in }, onError: @escaping (Error) -> Void = { _ in }) {
        isAdding = true
        addTaxiPartyUseCase.addTaxiParty(taxiParty, user: user)
            .sink { [weak self] completion in
                guard let self = self else {
                    return
                }
                if case let .failure(error) = completion {
                    onError(error)
                    self.error = .addPartyFail
                }
                self.isAdding = false
            } receiveValue: { taxiParty in
                self.addMyTaxiPartyInList(party: taxiParty)
                onSuccess(taxiParty)
            }.store(in: &cancelBag)
    }

    func leaveMyParty(party: TaxiParty, user: UserInfo) {
        myTaxiPartyUseCase.leaveTaxiParty(party, user: user) { [weak self] error in
            guard let self = self, error == nil else {
                self?.error = .leavePartyFail
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

    func joinTaxiParty(in taxiParty: TaxiParty, _ user: UserInfo, completion: @escaping () -> Void) {
        isAdding = true
        joinTaxiPartyUseCase.joinTaxiParty(in: taxiParty, user) { [weak self] taxiParty, _ in
            guard let self = self, let taxiParty = taxiParty else {
                self?.error = .outOfMember
                self?.isAdding = false
                return
            }
            if let index = self.taxiParties.firstIndex(of: taxiParty) {
                self.taxiParties.remove(at: index)
                self.addMyTaxiPartyInList(party: taxiParty)
                completion()
            }
            self.isAdding = false
        }
    }
}
