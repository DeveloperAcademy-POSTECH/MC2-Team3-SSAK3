//
//  DeleteUserUsecase.swift
//  Taxi
//
//  Created by JongHo Park on 2022/08/01.
//

import Combine

final class DeleteUserUsecase {

    private let authenticateAdapter: AuthenticateAdapter

    init(_ authenticateAdapter: AuthenticateAdapter = FirebaseAuthenticaterAdpater()) {
        self.authenticateAdapter = authenticateAdapter
    }

    func deleteUser(_ userInfo: UserInfo) -> AnyPublisher<Void, Error> {
        authenticateAdapter.deleteUser(with: userInfo)
    }

}
