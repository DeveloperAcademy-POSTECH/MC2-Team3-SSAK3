//
//  ResetPasswordViewModel.swift
//  Taxi
//
//  Created by 이윤영 on 2022/10/17.
//

import Combine
final class ResetPasswordViewModel: ObservableObject {
    // MARK: - Dependency
    private let resetPasswordUseCase: ResetPasswordUseCase

    // MARK: - Properties
    private var cancelBag: Set<AnyCancellable> = []

    // MARK: - States
    @Published var email: Validatable = Email()
    @Published private (set) var isLoading: Bool = false
    @Published private (set) var error: Error?
    @Published private (set) var userInfo: UserInfo?

    init(_ resetPasswordUseCase: ResetPasswordUseCase = ResetPasswordUseCase()) {
        self.resetPasswordUseCase = resetPasswordUseCase
    }
}

// MARK: - public API
extension ResetPasswordViewModel {
    func sendPasswordResetMail(onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        isLoading = true
        resetPasswordUseCase.sendPasswordReset(with: email.value + "@pos.idserve.net")
            .sink { completion in
                if case let .failure(error) = completion {
                    self.error = error
                    onError()
                }
                self.isLoading = false
            } receiveValue: { _ in
                onSuccess()
            }.store(in: &cancelBag)
    }
}
