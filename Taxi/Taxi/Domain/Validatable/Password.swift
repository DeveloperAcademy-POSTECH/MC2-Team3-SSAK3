//
//  Password.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/31.
//

import Foundation

struct Password: Validatable {
    let validator: Validator
    var value: String

    init(_ value: String = "", _ validator: Validator = BasePasswordValidator()) {
        self.validator = validator
        self.value = value
    }
}

private final class BasePasswordValidator: Validator {
    override init(_ validateConditions: [ValidateCondition] = [PasswordLengthCondition()],
                  _ successResult: ValidationResult = ValidationResult.valid(message: "사용 가능한 비밀번호입니다.")) {
        super.init(validateConditions, successResult)
    }
}

private struct PasswordLengthCondition: ValidateCondition {

    func isSatisfiedBy(_ value: String) -> ValidationResult {
        return value.count >= 6 ? .valid(message: "비밀번호 길이가 적당해요") : .invalid(cause: "너무 짧은 비밀번호입니다.")
    }

}
