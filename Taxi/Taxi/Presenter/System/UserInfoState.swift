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
    @Published private (set) var goToHomeEvent: Bool = false
    private var cancelBag: Set<AnyCancellable> = []

    // MARK: - Dependency
    private let deleteProfileImageUsecase: DeleteProfileImageUseCase
    private let changeNicknameUseCase: ChangeNicknameUseCase
    private let changeProfileImageUseCase: ChangeProfileImageUseCase
    private let deleteProfileImageUseCase: DeleteProfileImageUseCase
    private let deleteUserUsecase: DeleteUserUsecase

    init(_ userInfo: UserInfo,
         authenticateUseCase: DeleteProfileImageUseCase = DeleteProfileImageUseCase(),
         changeNicknameUseCase: ChangeNicknameUseCase = ChangeNicknameUseCase(),
         changeProfileImageUseCase: ChangeProfileImageUseCase = ChangeProfileImageUseCase(),
         deleteProfileImageUseCase: DeleteProfileImageUseCase = DeleteProfileImageUseCase(),
         deleteUserUsecase: DeleteUserUsecase = DeleteUserUsecase()
    ) {
        self.userInfo = userInfo
        self.deleteProfileImageUsecase = authenticateUseCase
        self.changeNicknameUseCase = changeNicknameUseCase
        self.changeProfileImageUseCase = changeProfileImageUseCase
        self.deleteProfileImageUseCase = deleteProfileImageUseCase
        self.deleteUserUsecase = deleteUserUsecase
    }

    func updateNickname(_ newName: String) {
        changeNicknameUseCase.changeNickname(userInfo, to: newName) { [weak self] user, error in
            guard let user = user, error == nil, let self = self else { return }
            self.userInfo = user
        }
    }

    func updateProfileImage(_ newImage: Data) {
        changeProfileImageUseCase.changeProfileImage(userInfo, to: newImage) { [weak self] user, error in
            guard let user = user, error == nil, let self = self else { return }
            self.userInfo = user
        }
    }

    func deleteProfileImage() {
        deleteProfileImageUseCase.deleteProfileImage(for: userInfo) { [weak self] user, error in
            guard let user = user, error == nil, let self = self else { return }
            self.userInfo = user
        }
    }

    func deleteUser() {
        deleteUserUsecase.deleteUser(userInfo)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    self.goToHomeEvent = true
                }
            } receiveValue: { _ in }
            .store(in: &cancelBag)
    }

}
