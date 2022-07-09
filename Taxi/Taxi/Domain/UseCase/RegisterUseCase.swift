//
//  RegisterUseCase.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/09.
//

import Combine

final class RegisterUseCase {
    private let authenticateAdapter: AuthenticateAdapter

    init(authenticateAdapter: AuthenticateAdapter = FirebaseAuthenticatorAdapter()) {
        self.authenticateAdapter = authenticateAdapter
    }

    func register(_ id: String, nickname: String) -> AnyPublisher<UserInfo, Error> {
        authenticateAdapter.register(id, nickname: nickname)
    }
}
