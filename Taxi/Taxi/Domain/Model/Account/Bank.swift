//
//  Bank.swift
//  Taxi
//
//  Created by JongHo Park on 2022/10/29.
//

enum Bank: Int, CaseIterable {
    case toss = 1
}

#if canImport(SwiftUI)
import SwiftUI
// MARK: - Image
extension Bank {
    var image: Image {
        switch self {
        case .toss:
            return Image("")
        }
    }
}
#endif

// MARK: - Bank Name
extension Bank {
    var name: String {
        switch self {
        case .toss:
            return "토스뱅크"
        }
    }
}
