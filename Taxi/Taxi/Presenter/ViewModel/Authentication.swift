//
//  Authentication.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/14.
//

import FirebaseAuth
import Foundation
import UIKit

final class Authentication: ObservableObject {
    @Published private (set) var user: User?
    @Published private (set) var userInfo: UserInfo?
    private let authenticateUseCase: AuthenticateUseCase = AuthenticateUseCase()
    private var userListener: AuthStateDidChangeListenerHandle?

    init() {
        user = Auth.auth().currentUser
        login(UIDevice.current.identifierForVendor!.uuidString, force: true)
    }

    private func addUserStateChangeListener() {
        userListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self, let user = user else {
                return
            }
            self.user = user
            self.login(user.uid, force: true)
        }
    }

    func login(_ id: String, force load: Bool = false) {
        authenticateUseCase.login(id, force: load) { user, error in
            guard let user = user, error == nil else { return }
            self.userInfo = user
        }
    }

    func updateNickname(_ newName: String) {
        guard let user = userInfo else { return }
        authenticateUseCase.changeNickname(user, to: newName) { user, error in
            guard let user = user, error == nil else { return }
            self.userInfo = user
        }
    }

    func updateProfileImage(_ newImage: Data) {
        guard let user = userInfo else { return }
        authenticateUseCase.changeProfileImage(user, to: newImage) { user, error in
            guard let user = user, error == nil else { return }
            self.userInfo = user
        }
    }

    func register(id: String, nickname: String) {
        authenticateUseCase.register(id, nickname) { user, error in
            guard let user = user, error == nil else { return }
            self.userInfo = user
        }
    }

    func deleteProfileImage() {
        guard let user = userInfo else { return }
        authenticateUseCase.deleteProfileImage(for: user) { user, error in
            guard let user = user, error == nil else { return }
            self.userInfo = user
        }
    }
}
