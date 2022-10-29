//
//  Account.swift
//  Taxi
//
//  Created by JongHo Park on 2022/10/29.
//

struct Account {
    let bank: Bank
    let accountNumber: String
    let owner: String

    init?(from accountDAO: AccountDAO) {
        guard let bank = Bank(rawValue: accountDAO.bankCode) else { return nil }
        self.bank = bank
        self.accountNumber = accountDAO.accountNumber
        self.owner = accountDAO.owner
    }

    init(bank: Bank, accountNumber: String, owner: String) {
        self.bank = bank
        self.owner = owner
        self.accountNumber = accountNumber
    }
}

extension Account: CustomStringConvertible {
    var description: String {
        "\(bank.name) \(accountNumber) \(owner)"
    }
}

struct AccountDAO: Codable {
    let bankCode: Int
    let accountNumber: String
    let owner: String

    init(from account: Account) {
        self.bankCode = account.bank.rawValue
        self.accountNumber = account.accountNumber
        self.owner = account.owner
    }
}
