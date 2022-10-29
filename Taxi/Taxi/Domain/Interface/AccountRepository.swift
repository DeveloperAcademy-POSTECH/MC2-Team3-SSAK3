//
//  AccountRepository.swift
//  Taxi
//
//  Created by JongHo Park on 2022/10/29.
//

protocol AccountRepository {
    func saveAccount(_ account: AccountDAO) throws
    func requestAccount() -> AccountDAO?
}
