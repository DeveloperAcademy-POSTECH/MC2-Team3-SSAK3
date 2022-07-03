//
//  SendEmailUseCase.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/03.
//

import Combine

final class SendEmailUseCase {

    private let repository: UserRepository
    private var cancelBag: Set<AnyCancellable> = []

    init(_ userRepository: UserRepository = UserFirebaseDataSource.shared) {
        self.repository = userRepository
    }

    func sendEmail(to email: Email, completion: @escaping (Error?) -> Void) {
        repository.sendSignInEmail(to: email)
            .sink { result in
                switch result {
                case .failure(let error):
                    completion(error)
                case .finished:
                    completion(nil)
                }
            } receiveValue: { _ in }
            .store(in: &cancelBag)
    }
}
