//
//  Authentication.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/14.
//

import Combine
import Foundation

final class UserInfoState: ObservableObject {
    @Published private (set) var userInfo: UserInfo
    private var cancelBag: Set<AnyCancellable> = []

    // MARK: - Dependency
    private let deleteProfileImageUsecase: DeleteProfileImageUseCase
    private let changeNicknameUseCase: ChangeNicknameUseCase
    private let changeProfileImageUseCase: ChangeProfileImageUseCase
    private let deleteProfileImageUseCase: DeleteProfileImageUseCase

    init(_ userInfo: UserInfo,
         authenticateUseCase: DeleteProfileImageUseCase = DeleteProfileImageUseCase(),
         changeNicknameUseCase: ChangeNicknameUseCase = ChangeNicknameUseCase(),
         changeProfileImageUseCase: ChangeProfileImageUseCase = ChangeProfileImageUseCase(),
         deleteProfileImageUseCase: DeleteProfileImageUseCase = DeleteProfileImageUseCase()) {
        self.userInfo = userInfo
        self.deleteProfileImageUsecase = authenticateUseCase
        self.changeNicknameUseCase = changeNicknameUseCase
        self.changeProfileImageUseCase = changeProfileImageUseCase
        self.deleteProfileImageUseCase = deleteProfileImageUseCase
    }

    func updateNickname(_ newName: String) {
        changeNicknameUseCase.changeNickname(userInfo, to: newName) { user, error in
            guard let user = user, error == nil else { return }
            self.userInfo = user
        }
    }

    func updateProfileImage(_ newImage: Data) {
        changeProfileImageUseCase.changeProfileImage(userInfo, to: newImage) { user, error in
            guard let user = user, error == nil else { return }
            self.userInfo = user
        }
    }

    func deleteProfileImage() {
        deleteProfileImageUseCase.deleteProfileImage(for: userInfo) { user, error in
            guard let user = user, error == nil else { return }
            self.userInfo = user
        }
    }
}
