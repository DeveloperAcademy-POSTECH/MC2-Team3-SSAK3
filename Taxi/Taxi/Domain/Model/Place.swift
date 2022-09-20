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
    case c5 = "C5"
    case jigok = "지곡회관"
    case fromChatting = "추후협의"
    case taxi = "택시승강장"
    case toilet = "화장실"
}
// MARK: - 코드 처리
extension Place {
    static func of(_ code: Int) -> Self {
        switch code {
        case 0:
            return .postech
        case 1:
            return .pohangStation
        case 2:
            return .c5
        case 3:
            return .jigok
        case 4:
            return .fromChatting
        case 5:
            return .taxi
        case 6:
            return .toilet
        default:
            fatalError("정의되지 않은 Place 코드")
        }
    }

    func toCode() -> Int {
        switch self {
        case .postech:
            return 0
        case .pohangStation:
            return 1
        case .c5:
            return 2
        case .jigok:
            return 3
        case .fromChatting:
            return 4
        case .taxi:
            return 5
        case .toilet:
            return 6
        }
    }
}
// MARK: - 도착장소, 출발장소 모음
extension Place {
    static func destinations() -> [Place] {
        [.postech, .pohangStation]
    }

    static func departures(of place: Place) -> [Place] {
        switch place {
        case .pohangStation:
            return [.c5, .jigok, .fromChatting]
        case .postech:
            // TODO: 포스텍 도착 시 출발 장소를 결정해야함
            return [.taxi, .toilet, .fromChatting]
        default:
            fatalError("Undefined destination")
        }
    }
}
