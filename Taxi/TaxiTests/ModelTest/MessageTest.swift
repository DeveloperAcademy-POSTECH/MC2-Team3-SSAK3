//
//  MessageTest.swift
//  TaxiTests
//
//  Created by JongHo Park on 2022/08/10.
//

@testable import Taxi
import XCTest

final class MessageTest: XCTestCase {
    func testMessageReadableMeetingTimeIsCorrect() {

        // given
        let message: Message = Message(id: "", sender: "", body: "", timeStamp: 202208100843334920, messageType: .normal)
        let message2: Message = Message(sender: "", body: "", timeStamp: 202208101259344920, messageType: .normal)
        // then
        XCTAssertEqual("08:43", message.sendTime)
        XCTAssertEqual("12:59", message2.sendTime)

    }
}
