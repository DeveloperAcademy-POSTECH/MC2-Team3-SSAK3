//
//  MessageMockData.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/15.
//

import Foundation

#if DEBUG
final class MessageMockData {
    static var mockMessages: [Message] = [
        Message(id: UUID().uuidString, sender: "1", body: "안녕하세요 테스트 메시지", timeStamp: 20221025194010, messageType: .normal),
        Message(id: UUID().uuidString, sender: "2", body: "택시 타세요?", timeStamp: 20221025194010, messageType: .normal),
        Message(id: UUID().uuidString, sender: "1", body: "아니요", timeStamp: 20221025194010, messageType: .normal),
        Message(id: UUID().uuidString, sender: "2", body: "뭐야 그럼 왜 온거야", timeStamp: 20221025194010, messageType: .normal),
        Message(id: UUID().uuidString, sender: "1", body: "당신을 죽이러 왔다", timeStamp: 20221025194010, messageType: .normal),
        Message(id: UUID().uuidString, sender: "1", body: "안녕하세요 테스트 메시지", timeStamp: 20221025194010, messageType: .normal),
        Message(id: UUID().uuidString, sender: "1", body: "안녕하세요 테스트 메시지", timeStamp: 20221025194010, messageType: .normal),
        Message(id: UUID().uuidString, sender: "1", body: "안녕하세요 테스트 메시지", timeStamp: 20221025194010, messageType: .normal),
        Message(id: UUID().uuidString, sender: "1", body: "Joy 님이 입장했습니다", timeStamp: 20221025194010, messageType: .normal),
        Message(id: UUID().uuidString, sender: "1", body: "안녕하세요 테스트 메시지", timeStamp: 20221025194010, messageType: .normal),
        Message(id: UUID().uuidString, sender: "1", body: "안녕하세요 테스트 메시지", timeStamp: 20221025194010, messageType: .normal),
        Message(id: UUID().uuidString, sender: "1", body: "안녕하세요 테스트 메시지", timeStamp: 20221025194010, messageType: .normal),
        Message(id: UUID().uuidString, sender: "2", body: "안녕하세요 테스트 메시지", timeStamp: 20221025194010, messageType: .normal),
        Message(id: UUID().uuidString, sender: "1", body: "안녕하세요 테스트 메시지", timeStamp: 20221025194010, messageType: .normal),
        Message(id: UUID().uuidString, sender: "1", body: "안녕하세요 테스트 메시지", timeStamp: 20221025194010, messageType: .normal),
        Message(id: UUID().uuidString, sender: "1", body: "안녕하세요 테스트 메시지", timeStamp: 20221025194010, messageType: .normal),
        Message(id: UUID().uuidString, sender: "2", body: "안녕하세요 테스트 메시지", timeStamp: 20221025194010, messageType: .normal),
        Message(id: UUID().uuidString, sender: "1", body: "안녕하세요 테스트 메시지", timeStamp: 20221025194010, messageType: .normal),
        Message(id: UUID().uuidString, sender: "1", body: "안녕하세요 테스트 메시지", timeStamp: 20221025194010, messageType: .normal)
    ]

    static var mockMessage: Message {
        Message(id: UUID().uuidString, sender: "1", body: "안녕하세요 테스트 메시지", timeStamp: 1, messageType: .normal)
    }
}
#endif
