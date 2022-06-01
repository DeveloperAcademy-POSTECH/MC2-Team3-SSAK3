//
//  Authentication.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/01.
//

import Foundation
import FirebaseAuth

final class Authentication {

    typealias Email = String

    func sendSignInEmail(to email: Email, _ completion: ((Error?) -> Void)? = nil) {
        // MARK: 딥링크 관련 정보를 담고 있는 Action Code Setting 인스턴스 생성 함수
        func makeActionCodeSetting(of email: Email) -> ActionCodeSettings {
            let actionCodeSettings = ActionCodeSettings()
            var urlComponent: URLComponents = URLComponents()
            urlComponent.scheme = "https"
            urlComponent.host = "ssak3-297ee.firebaseapp.com"
            urlComponent.queryItems = [URLQueryItem(name: "email", value: email)]
            actionCodeSettings.url = urlComponent.url
            actionCodeSettings.handleCodeInApp = true
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
            return actionCodeSettings
        }
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: makeActionCodeSetting(of: email), completion: completion)
    }
}
