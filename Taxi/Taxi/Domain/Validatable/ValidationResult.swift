//
//  ValidationResult.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/30.
//

enum ValidationResult {
    case empty(message: String)
    case valid(message: String)
    case invalid(cause: String)
}
