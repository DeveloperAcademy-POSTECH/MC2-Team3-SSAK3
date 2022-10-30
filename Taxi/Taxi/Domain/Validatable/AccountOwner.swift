//
//  AccountOwner.swift
//  Taxi
//
//  Created by JongHo Park on 2022/10/29.
//

import Foundation

struct AccountOwner: Validatable {
    let validator: Validator
    var value: String

    init(_ value: String = "",
         _ validator: Validator = BaseAccountOwnerValidator()) {
        self.value = value
        self.validator = validator
    }
}

private final class BaseAccountOwnerValidator: Validator {
    override init(_ validateConditions: [ValidateCondition] = [AccountOwnerLengthCondition()],
                  _ successResult: ValidationResult = .valid(message: "멋진 이름이네요!")) {
        super.init(validateConditions, successResult)
    }
}

private struct AccountOwnerLengthCondition: ValidateCondition {
    private let maxLength: Int = 10
    private let minLength: Int = 1

    func isSatisfiedBy(_ value: String) -> ValidationResult {
        let count = value.count
        return count >= minLength && count <= maxLength ? .valid(message: "\(value)님이 맞나요?"): .invalid(cause: "계좌주인 길이는 1자 이상 10자 이하에요.")
    }
}
