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
    case noFirebaseAuth
    case needToRegister
}

extension FirebaseAuthenticateError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noEmailLink:
            return "Email Link is not exist"
        case .noFirebaseAuth:
            return "No Firebase Auth"
        case .needToRegister:
            return "아직 회원가입을 안한 유저"
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

    func register(nickname: String) -> AnyPublisher<UserInfo, Error> {
        guard let user = firebaseAuth.currentUser else {
            return Fail(outputType: UserInfo.self, failure: FirebaseAuthenticateError.noFirebaseAuth).eraseToAnyPublisher()
        }
        return userRepository.setUser(user.uid, nickname)
    }

    func sendEmail(to email: Email) -> AnyPublisher<Void, Error> {
        func makeActionCodeSetting(of email: Email) -> ActionCodeSettings {
            let actionCodeSettings = ActionCodeSettings()
            var urlComponent: URLComponents = URLComponents()
            urlComponent.scheme = "https"
            urlComponent.host = "ssak3-297ee.firebaseapp.com"
            urlComponent.queryItems = [URLQueryItem(name: "email", value: email)]
            actionCodeSettings.url = urlComponent.url
            actionCodeSettings.handleCodeInApp = true
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
            return actionCodeSettings
        }
        return Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: makeActionCodeSetting(of: email))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
