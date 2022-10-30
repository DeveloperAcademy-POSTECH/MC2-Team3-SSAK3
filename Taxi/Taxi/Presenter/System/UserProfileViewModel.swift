//
//  UserProfileViewModel.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/16.
//

import Foundation

final class UserProfileViewModel: ObservableObject {
    @Published private (set) var user: UserInfo?
    private let getUserInfoUseCase: GetUserInfoUseCase

    init(getUserInfoUseCase: GetUserInfoUseCase = GetUserInfoUseCase()) {
        self.getUserInfoUseCase = getUserInfoUseCase
    }

    func getUser(_ id: String) {
        getUserInfoUseCase.getUserInfo(id) { [weak self] user, error in
            guard let self = self, error == nil, let user = user else { return }
            DispatchQueue.main.async {
                self.user = user
            }
        }
    }
}
