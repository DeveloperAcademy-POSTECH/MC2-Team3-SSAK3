//
//  AddTaxiPartyUsecaseTest.swift
//  TaxiTests
//
//  Created by JongHo Park on 2022/06/13.
//

@testable import Taxi
import XCTest

class AddTaxiPartyUsecaseTest: XCTestCase {
    private let addTaxiPartyUsecase: AddTaxiPartyUseCase = AddTaxiPartyUseCase()

    func testAddTaxiPartyCompletionHandler() {
        // given
        let taxiParty: TaxiParty = TaxiParty(id: "캐쉰캐샤", departureCode: Place.cafebene.toCode(), destinationCode: Place.pohangStation.toCode(), meetingDate: 1, meetingTime: 1, maxPersonNumber: 3, members: ["1"], isClosed: false)
        let promise = expectation(description: "Add Taxi Party Success!")
        var error: Error?
        // when
        addTaxiPartyUsecase.addTaxiParty(taxiParty) { taxiParty, err in
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
