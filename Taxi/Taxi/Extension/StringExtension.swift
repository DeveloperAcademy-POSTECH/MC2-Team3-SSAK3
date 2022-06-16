//
//  StringExtension.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/15.
//

import Foundation

extension String {
    var isValidNickname: FieldState {
        guard !nickname.isEmpty else { return .normal }
        let pattern = "^[ㄱ-하-ㅣ가-힣A-Za-z0-9]*$"
        guard nickname.range(of: pattern, options: .regularExpression) != nil else { return .invalid }
        return .valid
    }
}
