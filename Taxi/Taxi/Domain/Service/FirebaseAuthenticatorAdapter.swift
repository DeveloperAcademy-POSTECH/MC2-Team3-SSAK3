//
//  AuthenticateService.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/08.
//

import Combine
import FirebaseAuth
import FirebaseAuthCombineSwift

enum FirebaseAuthenticateError: Error {
    case emailUnVerified
}

extension FirebaseAuthenticateError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emailUnVerified:
            return NSLocalizedString("입력하신 이메일로 메일을 전송했습니다.\n이메일을 인증 후 다시 시도해주세요", comment: "Email Unverified")
        }
    }
}

final class FirebaseAuthenticaterAdpater: AuthenticateAdapter {

    private let userRepository: UserRepository

    init(_ userRepository: UserRepository = UserFirebaseDataSource.shared) {
        self.userRepository = userRepository
    }

    func login(with email: String, with password: String) -> AnyPublisher<UserInfo, Error> {
        Auth.auth().signIn(withEmail: email, password: password)
            .flatMap { [self] result in
                self.makeLoginPublisher(user: result.user)
            }
            .eraseToAnyPublisher()
    }

    func register(with email: String, with password: String, nickname: String) -> AnyPublisher<UserInfo, Error> {
        Auth.auth().createUser(withEmail: email, password: password)
            .map(\.user)
            .flatMap { [self] user in
                return userRepository.setUser(user.uid, nickname)
                    .combineLatest(user.sendEmailVerification())
            }
            .map(\.0)
            .eraseToAnyPublisher()
    }

}

// MARK: - private functions
private extension FirebaseAuthenticaterAdpater {

    func makeLoginPublisher(user: User) -> AnyPublisher<UserInfo, Error> {
        if user.isEmailVerified {
            return userRepository.getUser(user.uid, force: true)
        } else {
            return Fail(outputType: UserInfo.self, failure: FirebaseAuthenticateError.emailUnVerified)
                .eraseToAnyPublisher()
        }
    }

}
