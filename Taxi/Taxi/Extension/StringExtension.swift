//
//  StringExtension.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/15.
//

import Foundation

extension String {
    var isInValidNickname: Bool {
        guard !self.isEmpty else { return false }
        let pattern = "^[ㄱ-하-ㅣ가-힣A-Za-z0-9]*$"
        guard self.range(of: pattern, options: .regularExpression) != nil else { return true }
        return false
    }
}
