//
//  ChattingUseCaseTest.swift
//  TaxiTests
//
//  Created by JongHo Park on 2022/06/15.
//

@testable import Taxi
import XCTest

class ChattingUseCaseTest: XCTestCase {

    private let chattingUseCase: ChattingUseCase = ChattingUseCase.shared

    func testSendChattingCompletionHandler() {
        // given
        let promise = expectation(description: "send chatting message success!")
        var error: Error?
        let message: Message = Message(id: UUID().uuidString, sender: "1", body: "안녕하세요 테스트메시지임", timeStamp: 202203291715, typeCode: 0)
        let taxiParty: TaxiParty = TaxiParty(id: "캐쉰캐샤", departureCode: 6, destinationCode: 1, meetingDate: 0, meetingTime: 0, maxPersonNumber: 0, members: [], isClosed: false)
        // when
        chattingUseCase.sendMessage(message, to: taxiParty) { err in
            error = err
            promise.fulfill()
        }
        // then
        wait(for: [promise], timeout: 5)
        XCTAssertNil(error)
    }

}
