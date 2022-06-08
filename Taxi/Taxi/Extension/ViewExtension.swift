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
            .overlay(Rectangle().frame(height: 2).foregroundColor(.gray.opacity(0.3)).padding(.top, 40).padding(.bottom, 20))
    }

    // 가입 code check후 변화하는 text modifier
    func customTextStyle(isTrue: Bool) -> some View {
        modifier(CustomTextModifier(isTrue: isTrue))
    }
}
