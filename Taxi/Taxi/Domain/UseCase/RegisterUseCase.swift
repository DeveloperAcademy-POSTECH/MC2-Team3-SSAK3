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

    init(authenticateAdapter: AuthenticateAdapter = FirebaseAuthenticaterAdpater()) {
        self.authenticateAdapter = authenticateAdapter
    }

    func register(with email: String, _ password: String, _ nickname: String) -> AnyPublisher<UserInfo, Error> {
        authenticateAdapter.register(with: email, with: password, nickname: nickname)
    }

    func register(with email: String, _ password: String, _ nickname: String, completion: @escaping (UserInfo?, Error?) -> Void) {
        authenticateAdapter.register(with: email, with: password, nickname: nickname)
            .sink { result in
                if case let .failure(error) = result {
                    completion(nil, error)
                }
            } receiveValue: { userInfo in
                completion(userInfo, nil) 
            }.store(in: &cancelBag)
    }
}
