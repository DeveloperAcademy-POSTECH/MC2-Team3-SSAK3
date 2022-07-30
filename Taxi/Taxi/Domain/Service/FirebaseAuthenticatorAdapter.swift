//
//  AuthenticateService.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/08.
//

import Combine
import FirebaseAuth
import FirebaseAuthCombineSwift

final class FirebaseAuthenticaterAdpater: AuthenticateAdapter {

    private let userRepository: UserRepository

    init(_ userRepository: UserRepository = UserFirebaseDataSource.shared) {
        self.userRepository = userRepository
    }

    func login(with email: Email, with password: String) -> AnyPublisher<UserInfo, Error> {
        fatalError("need to implement")
        Auth.auth().signIn(withEmail: email, password: password)
    }

    func register(with email: Email, with password: String, nickname: String) -> AnyPublisher<UserInfo, Error> {
        fatalError("need to implement")
    }

}
