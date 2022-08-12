//
//  NavigationModifier.swift
//  Taxi
//
//  Created by JongHo Park on 2022/08/12.
//

import SwiftUI

private struct CustomNavigationModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .introspectNavigationController { navController in
                navController.enableCustomNavigationController()
            }
    }
}

extension View {
    func enableCustomNavigationView() -> some View {
        return modifier(CustomNavigationModifier())
    }
}
