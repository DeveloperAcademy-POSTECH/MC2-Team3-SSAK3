//
//  EmailSendView.swift
//  Taxi
//
//  Created by Yosep on 2022/10/17.
//

import MessageUI
import SwiftUI

final class EmailHelper: NSObject {
    static let shared = EmailHelper()
    private override init() {}
}

extension EmailHelper {
    func send(subject: String, body: String, recipient: [String]) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let rootVC = windowScenes?.keyWindow?.rootViewController
        guard let viewController = rootVC else {
            return
        }
        if !MFMailComposeViewController.canSendMail() {
            let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let mails = recipient.joined(separator: ",")
            let alert = UIAlertController(title: "Mail 앱을 열 수 없습니다.", message: "아래 버튼을 눌러 Mail 앱을 연동 해주세요.", preferredStyle: .actionSheet)

            if let defaultUrl = URL(string: "mailto:\(mails)?subject=\(subjectEncoded)&body=\(bodyEncoded)"),
               UIApplication.shared.canOpenURL(defaultUrl) {
                alert.addAction(UIAlertAction(title: "Mail", style: .default, handler: { _ in
                    UIApplication.shared.open(defaultUrl)
                }))
            }

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
            return
        }
        let mailCompose = MFMailComposeViewController()
        mailCompose.setSubject(subject)
        mailCompose.setMessageBody(body, isHTML: false)
        mailCompose.setToRecipients(recipient)
        mailCompose.mailComposeDelegate = self
        viewController.present(mailCompose, animated: true, completion: nil)
    }
}

extension EmailHelper: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
