//
//  AuthenticateService.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/08.
//

import Combine

protocol AuthenticateAdapter {
    func login(with email: Email) -> AnyPublisher<UserInfo, Error>
    func register(_ id: String, nickname: String) -> AnyPublisher<UserInfo, Error>
    func sendEmail(to email: Email) -> AnyPublisher<Void, Error>
}
