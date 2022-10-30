//
//  UserDefaultsAccountRepository.swift
//  Taxi
//
//  Created by JongHo Park on 2022/10/29.
//

import Foundation

struct UserDefaultsAccountRepository: AccountRepository {

    func saveAccount(_ account: AccountDAO) throws {
        let data: Data = try JSONEncoder().encode(account)
        UserDefaults.standard.set(data, forKey: "account")
    }

    func requestAccount() -> AccountDAO? {
        guard let data: Data = UserDefaults.standard.data(forKey: "account") else {
            return nil
        }
        guard let ret: AccountDAO = try? JSONDecoder().decode(AccountDAO.self, from: data) else {
            return nil
        }
        return ret
    }
}
