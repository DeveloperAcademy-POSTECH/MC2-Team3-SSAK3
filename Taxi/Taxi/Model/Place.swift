//
//  Place.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/04.
//

import Foundation

enum Place: String {
    case postech = "포스텍"
    case pohangStation = "포항역"

    static func of(_ code: Int) -> Self {
        switch code {
        case 0:
            return .postech
        case 1:
            return .pohangStation
        default:
            fatalError("정의되지 않은 Place 코드")
        }
    }
}
