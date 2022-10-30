//
//  AccountNumber.swift
//  Taxi
//
//  Created by JongHo Park on 2022/10/29.
//

import Foundation

struct AccountNumber: Validatable {
    let validator: Validator
    var value: String

    init(_ value: String = "",
         _ validator: Validator = BaseAccountNumberValidator()) {
        self.value = value
        self.validator = validator
    }
}

private final class BaseAccountNumberValidator: Validator {
    override init(_ validateConditions: [ValidateCondition] = [AccountNumberLengthCondition()],
                  _ successResult: ValidationResult = .valid(message: "적당한 계좌번호에요.")) {
        super.init(validateConditions, successResult)
    }
}

private struct AccountNumberLengthCondition: ValidateCondition {
    private let maxLength: Int = 16
    private let minLength: Int = 8

    func isSatisfiedBy(_ value: String) -> ValidationResult {
        let count = value.count
        return count >= minLength && count <= maxLength ? .valid(message: "적당한 계좌번호에요"): .invalid(cause: "계좌번호 길이는 8자 이상 16자 이하에요.")
    }
}
