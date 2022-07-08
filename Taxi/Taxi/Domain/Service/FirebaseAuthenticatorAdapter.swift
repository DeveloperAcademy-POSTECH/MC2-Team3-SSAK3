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
    case noEmailLink
}

extension FirebaseAuthenticateError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noEmailLink:
            return "Email Link is not exist"
        }
    }
}

final class FirebaseAuthenticatorAdapter: AuthenticateAdapter {

    // MARK: - Firebase Authenticator
    private let firebaseAuth: Auth = Auth.auth()
    // MARK: - User Repository
    private let userRepository: UserRepository

    init(userRepository: UserRepository = UserFirebaseDataSource.shared) {
        self.userRepository = userRepository
    }

    func login(with email: Email) -> AnyPublisher<UserInfo, Error> {
        if let user = firebaseAuth.currentUser {
            return userRepository.getUser(user.uid, force: true)
        }

        let link: String? = UserDefaults.standard.string(forKey: "link")
        guard let link = link else {
            return Fail(outputType: UserInfo.self, failure: FirebaseAuthenticateError.noEmailLink).eraseToAnyPublisher()
        }

        return firebaseAuth.signIn(withEmail: email, link: link)
            .map(\.user)
            .flatMap { user in
                self.userRepository.getUser(user.uid, force: true)
            }
            .eraseToAnyPublisher()
    }
}
