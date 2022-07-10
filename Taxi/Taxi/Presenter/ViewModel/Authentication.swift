//
//  Authentication.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/14.
//

import Combine
import Foundation

protocol Authenticate {
    func login(with email: Email)
    func register(_ id: String, _ nickname: String)
}

final class Authentication: ObservableObject {
    @Published private (set) var userInfo: UserInfo?
    @Published private (set) var needToRegister: Bool = false
    private var cancelBag: Set<AnyCancellable> = []

    // MARK: - Dependency
    private let authenticateUseCase: DeleteProfileImageUseCase
    private let loginUseCase: LoginUseCase
    private let registerUseCase: RegisterUseCase
    private let changeNicknameUseCase: ChangeNicknameUseCase
    private let changeProfileImageUseCase: ChangeProfileImageUseCase
    private let deleteProfileImageUseCase: DeleteProfileImageUseCase

    init(authenticateUseCase: DeleteProfileImageUseCase = DeleteProfileImageUseCase(),
         loginUseCase: LoginUseCase = LoginUseCase(),
         registerUseCase: RegisterUseCase = RegisterUseCase(),
         changeNicknameUseCase: ChangeNicknameUseCase = ChangeNicknameUseCase(),
         changeProfileImageUseCase: ChangeProfileImageUseCase = ChangeProfileImageUseCase(),
         deleteProfileImageUseCase: DeleteProfileImageUseCase = DeleteProfileImageUseCase()) {
        self.authenticateUseCase = authenticateUseCase
        self.loginUseCase = loginUseCase
        self.registerUseCase = registerUseCase
        self.changeNicknameUseCase = changeNicknameUseCase
        self.changeProfileImageUseCase = changeProfileImageUseCase
        self.deleteProfileImageUseCase = deleteProfileImageUseCase
        login(with: "")
    }

    func updateNickname(_ newName: String) {
        guard let user = userInfo else { return }
        changeNicknameUseCase.changeNickname(user, to: newName) { user, error in
            guard let user = user, error == nil else { return }
            self.userInfo = user
        }
    }

    func updateProfileImage(_ newImage: Data) {
        guard let user = userInfo else { return }
        changeProfileImageUseCase.changeProfileImage(user, to: newImage) { user, error in
            guard let user = user, error == nil else { return }
            self.userInfo = user
        }
    }

    func register(id: String, nickname: String) {
        registerUseCase.register(id, nickname) { user, error in
            guard let user = user, error == nil else { return }
            self.userInfo = user
        }
    }

    func deleteProfileImage() {
        guard let user = userInfo else { return }
        deleteProfileImageUseCase.deleteProfileImage(for: user) { user, error in
            guard let user = user, error == nil else { return }
            self.userInfo = user
        }
    }
}

extension Authentication: Authenticate {
    func login(with email: Email) {
        loginUseCase.login(with: email)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.needToRegister = self.checkError(error)
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] userInfo in
                guard let self = self else {
                    return
                }
                self.userInfo = userInfo
            }.store(in: &cancelBag)
    }

    private func checkError(_ error: Error) -> Bool {
        return true
    }

    func register(_ id: String, _ nickname: String) {
        registerUseCase.register(id, nickname)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] userInfo in
                guard let self = self else {
                    return
                }
                self.userInfo = userInfo
            }.store(in: &cancelBag)
    }
}
