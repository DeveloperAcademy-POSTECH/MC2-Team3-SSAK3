//
//  AppState.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/18.
//

import Combine
import SwiftUI

final class AppState: ObservableObject {

    // MARK: - States
    @Published var tab: Tab = .taxiParty
    @Published var showChattingRoom: Bool = false
    @Published var currentUserInfo: UserInfo?
    @Published var showToastMessage: Bool = false

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
        self.currentUserInfo = nil
    }
}

// MARK: - Internal functions
private extension AppState {
    func autoLogin() {
        let email: String? = UserDefaults.standard.string(forKey: "email")
        let password: String? = UserDefaults.standard.string(forKey: "password")
        guard let email = email, let password = password else {
            return
        }
        loginUsecase.login(with: email, password: password)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] userInfo in
                guard let self = self else { return }
                self.currentUserInfo = userInfo
            }.store(in: &cancelBag)
    }
}
