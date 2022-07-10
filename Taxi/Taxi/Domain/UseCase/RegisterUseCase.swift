//
//  RegisterUseCase.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/09.
//

import Combine

final class RegisterUseCase {
    private let authenticateAdapter: AuthenticateAdapter
    private var cancelBag: Set<AnyCancellable> = []

    init(authenticateAdapter: AuthenticateAdapter = FirebaseAuthenticatorAdapter()) {
        self.authenticateAdapter = authenticateAdapter
    }

    func register(_ nickname: String) -> AnyPublisher<UserInfo, Error> {
        authenticateAdapter.register(nickname: nickname)
    }

    func register(_ nickname: String, completion: @escaping (UserInfo?, Error?) -> Void) {
        authenticateAdapter.register(nickname: nickname)
            .sink { result in
                if case let .failure(error) = result {
                    completion(nil, error)
                }
            } receiveValue: { userInfo in
                completion(userInfo, nil) 
            }.store(in: &cancelBag)
    }
}
