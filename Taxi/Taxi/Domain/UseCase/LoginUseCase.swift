//
//  loginUserCase.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/08.
//

import Combine

final class LoginUseCase {
    private let authenticator: AuthenticateAdapter

    init(authenticator: AuthenticateAdapter = FirebaseAuthenticatorAdapter()) {
        self.authenticator = authenticator
    }

    func login(with email: Email) -> AnyPublisher<UserInfo, Error> {
        return authenticator.login(with: email)
    }
}
