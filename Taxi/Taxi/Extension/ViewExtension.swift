//
//  ViewExtension.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/08.
//

import Foundation
import SwiftUI

extension View {
    // signUp 페이지 textfield underline 추가
    func underlineTextField() -> some View {
        self
            .overlay(Rectangle().frame(height: 2).foregroundColor(.gray.opacity(0.3)).padding(.top, 50).padding(.bottom, 20))
    }
}
