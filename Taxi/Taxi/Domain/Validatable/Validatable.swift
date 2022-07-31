//
//  Validatable.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/30.
//

protocol Validatable {
    var value: String { get set }
    var validator: Validator { get }
}

extension Validatable {
    func validate() -> ValidationResult {
        validator.validate(value)
    }
}

class Validator {

    final private let validateConditions: [ValidateCondition]
    final private let successResult: ValidationResult

    init(_ validateConditions: [ValidateCondition], _ successResult: ValidationResult) {
        self.validateConditions = validateConditions
        self.successResult = successResult
    }

    final fileprivate func validate(_ value: String) -> ValidationResult {
        for condition in validateConditions {
            let result: ValidationResult = condition.isSatisfiedBy(value)
            if case ValidationResult.invalid = result {
                return result
            }
        }
        return successResult
    }

}

protocol ValidateCondition {
    func isSatisfiedBy(_ value: String) -> ValidationResult
}
