//
//  ViewExtension.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/08.
//

import Foundation
import SwiftUI

extension View {
    func underlineTextField() -> some View {
        self
            .overlay(Rectangle().frame(height: 2).foregroundColor(.gray.opacity(0.3)).padding(.top, 40))
    }
}
