//
//  MyTaxiPartyUsecaseTest.swift
//  TaxiTests
//
//  Created by JongHo Park on 2022/06/13.
//

@testable import Taxi
import XCTest

class MyTaxiPartyUsecaseTest: XCTestCase {
    private let myTaxiPartyUsecase: MyTaxiPartyUseCase = MyTaxiPartyUseCase()

    func testGetMyTaxiPartyCompletionHandler() {
        // given
        let promise = expectation(description: "Get My TaxiParty Success!")
        var error: Error?
        let user: User = User(id: "1", nickname: "호종이", profileImage: nil)
        // when
        myTaxiPartyUsecase.getMyTaxiParty(user) { taxiParties, err in
            error = err
            if let taxiParties = taxiParties {
                print(taxiParties)
            }
            promise.fulfill()
        }
        // then
        wait(for: [promise], timeout: 5)
        XCTAssertNil(error)
    }

    func testLeaveMyTaxiPartyCompletionHandler() {
        // given
        let promise = expectation(description: "Leave TaxiParty Success!")
        var error: Error?
        let user: User = User(id: "1", nickname: "호종이", profileImage: nil)
        let taxiParty: TaxiParty = TaxiParty(id: "캐쉰캐샤", departureCode: Place.cafebene.toCode(), destinationCode: Place.pohangStation.toCode(), meetingDate: 1, meetingTime: 1, maxPersonNumber: 3, members: ["1"], isClosed: false)
        // when
        myTaxiPartyUsecase.leaveTaxiParty(taxiParty, user: user) { err in
            error = err
            promise.fulfill()
        }
        // then
        wait(for: [promise], timeout: 5)
        XCTAssertNil(error)
    }
}
