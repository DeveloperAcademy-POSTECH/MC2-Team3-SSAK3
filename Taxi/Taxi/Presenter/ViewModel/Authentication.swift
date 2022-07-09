//
//  Authentication.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/14.
//

import Combine
import Foundation

final class Authentication: ObservableObject {
    @Published private (set) var userInfo: UserInfo?
    private let authenticateUseCase: AuthenticateUseCase
    private let loginUseCase: LoginUseCase
    private let registerUseCase: RegisterUseCase
    private var cancelBag: Set<AnyCancellable> = []

    init(authenticateUseCase: AuthenticateUseCase = AuthenticateUseCase(),
         loginUseCase: LoginUseCase = LoginUseCase(),
         registerUseCase: RegisterUseCase = RegisterUseCase()) {
        self.authenticateUseCase = authenticateUseCase
        self.loginUseCase = loginUseCase
        self.registerUseCase = registerUseCase
        login(with: "")
    }

    func login(with email: Email) {
        loginUseCase.login(with: email)
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

    func register(_ id: String, nickname: String) {
        registerUseCase.register(id, nickname: nickname)
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
