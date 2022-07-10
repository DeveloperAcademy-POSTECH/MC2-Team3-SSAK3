//
//  SignManager.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/10.
//

import Combine
import Foundation
import FirebaseAuth
// 로그인, 회원가입 과정에서 데이터를 저장하고, 딥링크를 통해 회원가입 여부를 검사하는 매니저
final class SignManager: ObservableObject {
    @Published var email: Email = ""
    @Published var nickname: String = ""
    // 이메일 전송을 위한 UseCase
    private let sendEmailUseCase: SendEmailUseCase

    private var userInfo: UserInfo?
    private var cancelBag: Set<AnyCancellable> = []

    let emailPostfix: String = "@pos.idserve.net"

    init(_ getUserInfoUseCase: GetUserInfoUseCase = GetUserInfoUseCase(),
         _ sendEmailUseCase: SendEmailUseCase = SendEmailUseCase()) {
        self.sendEmailUseCase = sendEmailUseCase
    }

    // 인증 이메일 전송 함수
    func sendEmail() {
        sendEmailUseCase.sendEmail(to: email + emailPostfix) { error in
            if let error = error {
                print(error)
            }
        }
    }

    func handleDeepLink(url: String) {
        UserDefaults.standard.set(url, forKey: "link")
    }
}
