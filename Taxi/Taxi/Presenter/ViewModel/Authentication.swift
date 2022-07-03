//
//  Authentication.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/14.
//

import Foundation
import UIKit

final class Authentication: ObservableObject {
    @Published private (set) var user: UserInfo?
    private let authenticateUseCase: AuthenticateUseCase = AuthenticateUseCase()

    init() {
        login(UIDevice.current.identifierForVendor!.uuidString, force: true)
    }

    func login(_ id: String, force load: Bool = false) {
        authenticateUseCase.login(id, force: load) { user, error in
            guard let user = user, error == nil else { return }
            self.user = user
        }
    }

    func updateNickname(_ newName: String) {
        guard let user = user else { return }
        authenticateUseCase.changeNickname(user, to: newName) { user, error in
            guard let user = user, error == nil else { return }
            self.user = user
        }
    }

    func updateProfileImage(_ newImage: Data) {
        guard let user = user else { return }
        authenticateUseCase.changeProfileImage(user, to: newImage) { user, error in
            guard let user = user, error == nil else { return }
            self.user = user
        }
    }

    func register(id: String, nickname: String) {
        authenticateUseCase.register(id, nickname) { user, error in
            guard let user = user, error == nil else { return }
            self.user = user
        }
    }

    func deleteProfileImage() {
        guard let user = user else { return }
        authenticateUseCase.deleteProfileImage(for: user) { user, error in
            guard let user = user, error == nil else { return }
            self.user = user
        }
    }
}
