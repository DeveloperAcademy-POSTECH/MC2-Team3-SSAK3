//
//  ResetPasswordUseCase.swift
//  Taxi
//
//  Created by 이윤영 on 2022/10/17.
//
import Combine

final class ResetPasswordUseCase {
    private let authenticateAdapter: AuthenticateAdapter
    private var cancelBag: Set<AnyCancellable> = []

    init(authenticateAdapter: AuthenticateAdapter = FirebaseAuthenticaterAdpater()) {
        self.authenticateAdapter = authenticateAdapter
    }

    func sendPasswordReset(with email: String) -> AnyPublisher<Void, Error> {
        authenticateAdapter.resetPassword(with: email)
    }

    func sendPasswordReset(with email: String, completion: @escaping (Error?) -> Void) {
        authenticateAdapter.resetPassword(with: email)
            .sink { result in
                if case let .failure(error) = result {
                    completion(error)
                }
            } receiveValue: { _ in
                completion(nil)
            }.store(in: &cancelBag)
    }
}
