//
//  Id.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/31.
//

import Foundation

struct Email: Validatable {
    let validator: Validator
    var value: String

    init(_ value: String = "", _ validator: Validator = BaseEmailValidator()) {
        self.validator = validator
        self.value = value
    }
}

fileprivate final class BaseEmailValidator: Validator {
    override init(_ validateConditions: [ValidateCondition] = [EmailCondition()],
                  _ successResult: ValidationResult = ValidationResult.valid(message: "사용 가능한 이메일입니다.")) {
        super.init(validateConditions, successResult)
    }
}

private struct EmailCondition: ValidateCondition {

    private let emailRegex: String = "[A-Z0-9a-z._%+-]+@pos.idserve.net"

    func isSatisfiedBy(_ value: String) -> ValidationResult {
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        return emailPred.evaluate(with: value + "@pos.idserve.net") ? ValidationResult.valid(message: "이메일 검증 성공") : ValidationResult.invalid(cause: "올바르지 않은 이메일입니다.")
    }

}
