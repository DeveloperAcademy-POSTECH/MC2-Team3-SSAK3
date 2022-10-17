//
//  EmailSendView.swift
//  Taxi
//
//  Created by Yosep on 2022/10/17.
//

import Foundation
import MessageUI

class EmailHelper: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = EmailHelper()

    func sendEmail(subject: String, body: String, recipient: String) {
        if !MFMailComposeViewController.canSendMail() {
            print("No mail account found")
            return
        }
        let picker = MFMailComposeViewController()

        picker.setSubject(subject)
        picker.setMessageBody(body, isHTML: true)
        picker.setToRecipients([recipient])
        picker.mailComposeDelegate = self

        EmailHelper.getRootViewController()?.present(picker, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        EmailHelper.getRootViewController()?.dismiss(animated: true, completion: nil)
    }

    static func getRootViewController() -> UIViewController? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let rootVC = windowScenes?.keyWindow?.rootViewController
        return rootVC
    }
}
