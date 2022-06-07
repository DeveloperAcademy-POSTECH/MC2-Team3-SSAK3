//
//  TaxiPartyRepositoryTest.swift
//  TaxiTests
//
//  Created by JongHo Park on 2022/06/07.
//

import Combine
@testable import Taxi
import XCTest

class TaxiPartyRepositoryTest: XCTestCase {

    private var taxiPartyRepository: TaxiPartyRepository!
    private var cancelBag: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testGetTaxiParty() throws {
        // given
        let promise = expectation(description: "Get Taxi Party Success!")
        var error: Error?
        // when
        taxiPartyRepository.getTaxiParty(exclude: nil, force: true)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    error = err
                default:
                    print("no error")
                }
                promise.fulfill()
            } receiveValue: { _ in }
            .store(in: &cancelBag)

        // then
        wait(for: [promise], timeout: 5)
        XCTAssertNil(error)
    }

    func testAddTaxiParty() throws {
        // given
        let promise = expectation(description: "Add Taxi Party Success!")
        let taxiParty: TaxiParty = TaxiParty(id: "테스트", departureCode: 0, destinationCode: 1, meetingDate: 0, meetingTime: 0, maxPersonNumber: 0, memebers: ["테스트 아이디"], isClosed: false)
        var error: Error?
        // when
        taxiPartyRepository.addTaxiParty(taxiParty)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    error = err
                default:
                    print("no error")
                }
                promise.fulfill()
            } receiveValue: { _ in }
            .store(in: &cancelBag)
        // then
        wait(for: [promise], timeout: 5)
        XCTAssertNil(error)
    }

    func testJoinTaxParty() throws {
        // given
        let promise = expectation(description: "Join Taxi Party Success")
        let taxiParty: TaxiParty = TaxiParty(id: "테스트", departureCode: 0, destinationCode: 1, meetingDate: 0, meetingTime: 0, maxPersonNumber: 0, memebers: ["테스트 아이디"], isClosed: false)
        var error: Error?
        // when
        taxiPartyRepository.joinTaxiParty(to: taxiParty)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    error = err
                default:
                    print("no error")
                }
                promise.fulfill()
            } receiveValue: { _ in }
            .store(in: &cancelBag)
        // then
        wait(for: [promise], timeout: 5)
        XCTAssertNil(error)
    }

}
