//
//  AccountViewModel.swift
//  Taxi
//
//  Created by JongHo Park on 2022/10/29.
//

import Foundation

final class AccountViewModel: ObservableObject {
    @Published private (set) var account: Account?
    private let repository: AccountRepository

    init(repository: AccountRepository = UserDefaultsAccountRepository()) {
        self.repository = repository
        guard let account = repository.requestAccount() else {
            return
        }
        self.account = Account(from: account)
    }

    func saveAccount(bank: Bank, accountNumber: String, owner: String) {
        self.account = Account(bank: bank, accountNumber: accountNumber, owner: owner)
        try? repository.saveAccount(AccountDAO(from: account!))
    }

}
