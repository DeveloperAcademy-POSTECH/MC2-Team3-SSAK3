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
    func register(_ nickname: String)
    func sendEmail(_ email: Email)
}

final class Authentication: ObservableObject {
    @Published private (set) var userInfo: UserInfo?
    private var cancelBag: Set<AnyCancellable> = []

    // MARK: - Dependency
    private let authenticateUseCase: DeleteProfileImageUseCase
    private let loginUseCase: LoginUseCase
    private let registerUseCase: RegisterUseCase
    private let changeNicknameUseCase: ChangeNicknameUseCase
    private let changeProfileImageUseCase: ChangeProfileImageUseCase
    private let deleteProfileImageUseCase: DeleteProfileImageUseCase
    private let sendEmailUseCase: SendEmailUseCase

    // MARK: - State Event
    @Published private (set) var isLoginProcessing: Bool = false
    @Published private (set) var isRegisterProcessing: Bool = false
    @Published var needToRegister: Bool = false
    @Published var waitingDeepLink: Bool = false

    init(authenticateUseCase: DeleteProfileImageUseCase = DeleteProfileImageUseCase(),
         loginUseCase: LoginUseCase = LoginUseCase(),
         registerUseCase: RegisterUseCase = RegisterUseCase(),
         changeNicknameUseCase: ChangeNicknameUseCase = ChangeNicknameUseCase(),
         changeProfileImageUseCase: ChangeProfileImageUseCase = ChangeProfileImageUseCase(),
         deleteProfileImageUseCase: DeleteProfileImageUseCase = DeleteProfileImageUseCase(),
         sendEmailUseCase: SendEmailUseCase = SendEmailUseCase()) {
        self.authenticateUseCase = authenticateUseCase
        self.loginUseCase = loginUseCase
        self.registerUseCase = registerUseCase
        self.changeNicknameUseCase = changeNicknameUseCase
        self.changeProfileImageUseCase = changeProfileImageUseCase
        self.deleteProfileImageUseCase = deleteProfileImageUseCase
        self.sendEmailUseCase = sendEmailUseCase
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
        isLoginProcessing = true
        loginUseCase.login(with: email)
            .sink { [weak self] completion in
                guard let self = self else {
                    return
                }
                switch completion {
                case .failure(let error):
                    print("\(error.localizedDescription)")
                case .finished:
                    print("finished")
                }
                self.isLoginProcessing = false
            } receiveValue: { [weak self] userInfo in
                guard let self = self else {
                    return
                }
                self.userInfo = userInfo
            }.store(in: &cancelBag)
    }

    func checkRegisterHistory() {
        loginUseCase.login(with: "")
            .sink { [weak self] completion in
                guard let self = self else {
                    return
                }
                if case let .failure(error) = completion {
                    self.needToRegister = self.checkError(error)
                }
            } receiveValue: { [weak self] userInfo in
                self?.userInfo = userInfo
            }.store(in: &cancelBag)
    }

    private func checkError(_ error: Error) -> Bool {
        if case FirebaseAuthenticateError.needToRegister = error {
            return true
        } else {
            return false
        }
    }

    func register(_ nickname: String) {
        isRegisterProcessing = true
        registerUseCase.register(nickname)
            .sink { [weak self] completion in
                guard let self = self else {
                    return
                }
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("finished")
                }
                self.isRegisterProcessing = false
            } receiveValue: { [weak self] userInfo in
                guard let self = self else {
                    return
                }
                self.userInfo = userInfo
            }.store(in: &cancelBag)
    }

    func sendEmail(_ email: Email) {
        sendEmailUseCase.sendEmail(to: email)
            .sink { result in
                switch result {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in }
            .store(in: &cancelBag)
    }
}
