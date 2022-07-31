//
//  SignUpViewModel.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/31.
//

import Combine
import Foundation

final class SignUpViewModel: ObservableObject {
    // MARK: - Dependency
    private let registerUsecase: RegisterUseCase

    // MARK: - Properties
    private var cancelBag: Set<AnyCancellable> = []
    // MARK: - States
    @Published var email: Validatable = Email()
    @Published var password: Validatable = Password()
    @Published var nickname: Validatable = Nickname()
    @Published private (set) var isLoading: Bool = false
    @Published private (set) var error: Error?
    @Published private (set) var registerCompletionEvent: Bool = false

    init(_ registerUsecase: RegisterUseCase = RegisterUseCase()) {
        self.registerUsecase = registerUsecase
    }
}

// MARK: - public API
extension SignUpViewModel {
    func register() {
        isLoading = true
        registerUsecase.register(with: email.value + "@pos.idserve.net", password.value, nickname.value)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.error = error
                case .finished:
                    self.registerCompletionEvent = true
                }
                self.isLoading = false
            } receiveValue: { _ in
            }.store(in: &cancelBag)
    }
}
