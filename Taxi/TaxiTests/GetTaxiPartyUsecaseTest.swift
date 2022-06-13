//
//  GetTaxiPartyUsecaseTest.swift
//  TaxiTests
//
//  Created by JongHo Park on 2022/06/13.
//

@testable import Taxi
import XCTest

class GetTaxiPartyUsecaseTest: XCTestCase {
    private let getTaxiPartyUsecase: GetTaxiPartyUseCase = GetTaxiPartyUseCase()

    func testGetTaxiPartyCompletionHandler() {
        // given
        let promise = expectation(description: "Get TaxiParty Success!")
        var error: Error?
        // when
        getTaxiPartyUsecase.getTaxiParty(exclude: nil, force: true) { taxiParties, err in
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
}
