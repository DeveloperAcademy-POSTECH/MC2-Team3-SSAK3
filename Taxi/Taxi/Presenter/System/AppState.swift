//
//  AppState.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/18.
//

import Combine
import SwiftUI

final class AppState: ObservableObject {

    // MARK: - Enums
    enum LoginState {
        case none
        case loading
        case succeed(UserInfo)
    }

    // MARK: - States
    @Published var tab: Tab = .taxiParty
    @Published var showChattingRoom: Bool = false
    @Published var showToastMessage: Bool = false
    @Published var loginState: LoginState = .none

    // MARK: - Properties
    private (set) var toastMessage: String = ""
    private let loginUsecase: LoginUseCase = LoginUseCase()
    private (set) var currentTaxiParty: TaxiParty?
    private var cancelBag: Set<AnyCancellable> = []

    // MARK: - Lifecycle
    init() {
        autoLogin()
    }
}

// MARK: - API
extension AppState {

    func showChattingRoom(_ taxiParty: TaxiParty) {
        tab = .myParty
        currentTaxiParty = taxiParty
        showChattingRoom = true
    }

    func showToastMessage(_ message: String) {
        self.toastMessage = message
        showToastMessage = true
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        self.loginState = .none
    }

    func showTaxiParties() {
        tab = .taxiParty
    }
}

// MARK: - Internal functions
private extension AppState {
    func autoLogin() {
        let email = UserDefaults.standard.string(forKey: "email")
        let password = UserDefaults.standard.string(forKey: "password")
        guard let email = email, let password = password else {
            self.loginState = .none
            return
        }
        self.loginState = .loading
        loginUsecase.login(with: email, password: password)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error)
                    self.loginState = .none
                }
            } receiveValue: { [weak self] userInfo in
                guard let self = self else { return }
                self.loginState = .succeed(userInfo)
            }.store(in: &cancelBag)
    }
}
