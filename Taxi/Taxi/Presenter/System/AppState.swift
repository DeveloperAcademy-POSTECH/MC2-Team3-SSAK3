//
//  AppState.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/18.
//

import Combine
import KeyChainWrapper
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
    @Published var isLoginFailed: Bool = false

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
        let email: String? = UserDefaults.standard.string(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "email")
        if let email = email, let bundleIdentifier = Bundle.main.bundleIdentifier {
            PasswordKeychainManager(service: bundleIdentifier)
                .removePassword(for: email)
        }
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
        guard let email = email, let bundleIdentifier = Bundle.main.bundleIdentifier else {
            self.loginState = .none
            return
        }
        self.loginState = .loading
        PasswordKeychainManager(service: bundleIdentifier).getPassword(for: email) { [weak self] password, error in
            guard let self = self else { return }
            guard error == nil else {
                DispatchQueue.main.async {
                    self.loginState = .none
                    self.isLoginFailed = true
                }
                return
            }
            if let password = password {
                self.loginUsecase.login(with: email, password: password)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure:
                            self.loginState = .none
                            self.isLoginFailed = true
                        }
                    } receiveValue: { [weak self] userInfo in
                        guard let self = self else { return }
                        self.loginState = .succeed(userInfo)
                    }.store(in: &self.cancelBag)
            } else {
                self.loginState = .none
            }
        }
    }
}
