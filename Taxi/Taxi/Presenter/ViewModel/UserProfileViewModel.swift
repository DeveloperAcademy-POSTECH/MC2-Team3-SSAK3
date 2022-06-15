//
//  UserProfileViewModel.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/16.
//

import Foundation

final class UserProfileViewModel: ObservableObject {
    @Published private (set) var membersInfo: [String: User] = [:]
    private let authenticateUseCase: AuthenticateUseCase = AuthenticateUseCase()

    func getMembersInfo(_ members: [String]) {
        for id in members {
            authenticateUseCase.login(id) { user, error in
                guard let user = user, error == nil else { return }
                self.membersInfo.updateValue(user, forKey: id)
            }
        }
    }
}
