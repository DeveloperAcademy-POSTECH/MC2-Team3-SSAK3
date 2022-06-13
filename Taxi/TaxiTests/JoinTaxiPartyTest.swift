//
//  JoinTaxiPartyTest.swift
//  TaxiTests
//
//  Created by JongHo Park on 2022/06/13.
//

@testable import Taxi
import XCTest

class JoinTaxiPartyTest: XCTestCase {
    private let joinTaxiPartyUsecase: JoinTaxiPartyUseCase = JoinTaxiPartyUseCase()

    func testJoinTaxiPartyCompletionHandler() {
        // given
        let promise = expectation(description: "Join TaxiParty Success!")
        let taxiParty: TaxiParty = TaxiParty(id: "캐쉰캐샤", departureCode: Place.cafebene.toCode(), destinationCode: Place.pohangStation.toCode(), meetingDate: 1, meetingTime: 1, maxPersonNumber: 3, members: ["1"], isClosed: false)
        let user: User = User(id: "1125125125", nickname: "호종이", profileImage: nil)
        var error: Error?
        // when
        joinTaxiPartyUsecase.joinTaxiParty(in: taxiParty, user) { taxiParty, err in
            error = err
            if let taxiParty = taxiParty {
                print(taxiParty)
            }
            promise.fulfill()
        }
        // then
        wait(for: [promise], timeout: 5)
        XCTAssertNil(error)
    }

}
