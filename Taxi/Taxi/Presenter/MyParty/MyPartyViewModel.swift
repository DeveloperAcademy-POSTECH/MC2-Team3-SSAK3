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

protocol AddTaxiPartyDelegete: AnyObject {
    func addTaxiParty(_ taxiParty: TaxiParty)
}

protocol JoinTaxiPartyDelegate: AnyObject {
    func joinTaxiParty(_ taxiParty: TaxiParty)
}

extension MyPartyView {
    final class ViewModel: ObservableObject {
        @Published private (set) var myParties: [TaxiParty] = []
        @Published var error: ListError?
        private var cancelBag: Set<AnyCancellable> = []

        // 유즈케이스
        private let addTaxiPartyUseCase: AddTaxiPartyUseCase = AddTaxiPartyUseCase()
        private let joinTaxiPartyUseCase: JoinTaxiPartyUseCase = JoinTaxiPartyUseCase()
        private let myTaxiPartyUseCase: MyTaxiPartyUseCase = MyTaxiPartyUseCase()
        private let userId: String

        init(userId: String) {
            self.userId = userId
            getMyTaxiParties(force: true)
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
    }
}

extension MyPartyView.ViewModel: AddTaxiPartyDelegete {

    func addTaxiParty(_ taxiParty: TaxiParty) {
        var copyToAdd = myParties
        copyToAdd.append(taxiParty)
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

}

extension MyPartyView.ViewModel: JoinTaxiPartyDelegate {

    func joinTaxiParty(_ taxiParty: TaxiParty) {
        addTaxiParty(taxiParty)
    }

}
