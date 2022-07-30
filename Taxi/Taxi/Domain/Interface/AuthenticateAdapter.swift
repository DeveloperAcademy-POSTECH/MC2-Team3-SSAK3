//
//  AuthenticateService.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/08.
//

import Combine

protocol AuthenticateAdapter {
    func login(with email: Email, with password: String) -> AnyPublisher<UserInfo, Error>
    func register(with email: Email, with password: String, nickname: String) -> AnyPublisher<UserInfo, Error>
}
