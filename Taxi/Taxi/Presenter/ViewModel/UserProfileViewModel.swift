//
//  UserProfileViewModel.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/16.
//

import Foundation

final class UserProfileViewModel: ObservableObject {
    @Published private (set) var user: User?
    private let authenticateUseCase: AuthenticateUseCase = AuthenticateUseCase()

    func getUser(_ id: String) {
        authenticateUseCase.login(id, force: true) { [weak self] user, error in
            guard let self = self, error == nil, let user = user else { return }
            self.user = user
        }
    }
}
