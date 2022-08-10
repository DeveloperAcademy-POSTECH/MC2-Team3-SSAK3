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
    let timeStamp: Int // (yyyyMMddHHmmssSSSS)
    let typeCode: Int // (0 - 일반 채팅, 1 - 입장 채팅)

    init(id: String = UUID().uuidString, sender: String, body: String, timeStamp: Int = getCurrentMessageTime(), messageType: MessageType) {
        self.id = id
        self.sender = sender
        self.body = body
        self.timeStamp = timeStamp
        self.typeCode = messageType.code
    }
}

// MARK: - Public Interface
extension Message {
    /// 메시지 전송 시간을 HH:mm 형태로 반환한다.
    var sendTime: String {
        guard let date: Date = Message.messageTimeFormatter.date(from: String(timeStamp)) else { return "알 수 없는 시간" }
        guard let hour: Int = date.hour, let minute: Int = date.minute else { return "알 수 없는 시간" }
        return "\(String(format: "%02d", hour)):\(String(format: "%02d", minute))"
    }
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

extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
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

// MARK: - Internal Impl (내부 구현)
private extension Message {
    static let messageTimeFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmssSSSS"
        return dateFormatter
    }()

    static func getCurrentMessageTime() -> Int {
        return Int(messageTimeFormatter.string(from: Date()))!
    }
}
