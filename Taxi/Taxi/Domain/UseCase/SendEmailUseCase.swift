//
//  SendEmailUseCase.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/03.
//

import Combine

final class SendEmailUseCase {

    private let service: AuthenticateAdapter
    private var cancelBag: Set<AnyCancellable> = []

    init(service: AuthenticateAdapter = FirebaseAuthenticatorAdapter()) {
        self.service = service
    }

    func sendEmail(to email: Email) -> AnyPublisher<Void, Error> {
        return service.sendEmail(to: email)
    }

    func sendEmail(to email: Email, completion: @escaping (Error?) -> Void) {
        service.sendEmail(to: email)
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
