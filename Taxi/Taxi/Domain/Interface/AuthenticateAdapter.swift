//
//  AuthenticateService.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/08.
//

import Combine

protocol AuthenticateAdapter {
    func login(with email: String, with password: String) -> AnyPublisher<UserInfo, Error>
    func register(with email: String, with password: String, nickname: String) -> AnyPublisher<UserInfo, Error>
    func deleteUser(with userInfo: UserInfo) -> AnyPublisher<Void, Error>
    func resetPassword(with email: String) -> AnyPublisher<Void, Error>
}
