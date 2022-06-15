//
//  Message.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/04.
//

import Foundation

struct Message: Codable {
    let id: String // (메시지의 고유 id)
    let sender: String // (보낸 유저의 고유 id)
    let body: String // 채팅 메시지
    let timeStamp: Int // (yyyyMMddhhmmss)
    let typeCode: Int // (0 - 일반 채팅, 1 - 입장 채팅)
}

extension Message: CustomStringConvertible {
    var description: String {
        switch type {
        case .normal:
            return "메시지 내용: \(body) 보낸 시간: \(timeStamp)"
        case .entrance:
            return "입장 유저: \(sender) 입장 시간: \(timeStamp)"
        }
    }
}

extension Message {
    var type: MessageType {
        switch typeCode {
        case 0:
            return .normal
        case 1:
            return .entrance
        default:
            fatalError("알 수 없는 메시지 타입")
        }
    }
}

extension Message {
    enum MessageType {
        case normal
        case entrance

        var code: Int {
            switch self {
            case .normal:
                return 0
            case .entrance:
                return 1
            }
        }
    }
}
