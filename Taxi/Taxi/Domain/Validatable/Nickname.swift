//
//  Nickname.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/31.
//

import Foundation

struct Nickname: Validatable {
    var value: String
    let validator: Validator

    init(value: String = "", validator: Validator = NicknameValidator()) {
        self.validator = validator
        self.value = value
    }
}

private final class NicknameValidator: Validator {

    override init(_ validateConditions: [ValidateCondition] = [NicknameLengthCondition()],
                  _ successResult: ValidationResult = .valid(message: "아카데미 내에서 사용중인 닉네임을 권장드려요")) {
        super.init(validateConditions, successResult)
    }

}

private struct NicknameLengthCondition: ValidateCondition {
    func isSatisfiedBy(_ value: String) -> ValidationResult {
        return value.count >= 1 && value.count <= 12 ? .valid(message: "글자 수가 적당해요") : .invalid(cause: "닉네임은 1글자 이상 12글자 이하여야 합니다.")
    }
}
