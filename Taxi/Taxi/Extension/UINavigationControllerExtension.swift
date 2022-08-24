//
//  UINavigationControllerExtension.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/18.
//

import SwiftUI

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        enableCustomNavigationController()
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }

    public func enableCustomNavigationController() {
        interactivePopGestureRecognizer?.delegate = self
    }

    public func disableCustomNavigationController() {
        interactivePopGestureRecognizer?.delegate = nil
    }
}
