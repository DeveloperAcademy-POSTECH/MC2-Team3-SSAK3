//
//  SignInViewModel.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/31.
//

import Combine
import Foundation

final class SignInViewModel: ObservableObject {
    // MARK: - Dependency
    private let loginUsecase: LoginUseCase

    // MARK: - Properties
    private var cancelBag: Set<AnyCancellable> = []

    // MARK: - States
    @Published var email: Validatable = Email()
    @Published var password: Validatable = Password()
    @Published private (set) var isLoading: Bool = false
    @Published private (set) var error: Error?
    @Published private (set) var userInfo: UserInfo?

    init(_ loginUsecase: LoginUseCase = LoginUseCase()) {
        self.loginUsecase = loginUsecase
    }
}

// MARK: - public API
extension SignInViewModel {
    func login() {
        isLoading = true
        loginUsecase.login(with: email.value + "@pos.idserve.net", password: password.value)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.error = error
                case .finished:
                    print("finished")
                }
                self.isLoading = false
            } receiveValue: { [weak self] userInfo in
                guard let self = self else { return }
                self.userInfo = userInfo
            }.store(in: &cancelBag)
    }
}
