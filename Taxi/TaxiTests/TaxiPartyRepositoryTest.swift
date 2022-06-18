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
        taxiPartyRepository = TaxiPartyFirebaseDataSource.shared
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testGetTaxiParty() throws {
        // given
        let promise = expectation(description: "Get Taxi Party Success!")
        var error: Error?
        // when
        taxiPartyRepository.getTaxiParty(exclude: "테스트 아이디1", force: true)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    error = err
                default:
                    print("no error")
                }
                promise.fulfill()
            } receiveValue: { taxiParties in
                print(taxiParties)
            }
            .store(in: &cancelBag)
        // then
        wait(for: [promise], timeout: 5)
        XCTAssertNil(error)
    }

    func testAddTaxiParty() throws {
        // given
        let promise = expectation(description: "Add Taxi Party Success!")
        let taxiParty: TaxiParty = TaxiParty(id: "테스트2", departureCode: 0, destinationCode: 1, meetingDate: 12, meetingTime: 12, maxPersonNumber: 4, members: ["테스트 아이디2"], isClosed: false)
        let user: User = User(id: "하이", nickname: "", profileImage: "")
        var error: Error?
        // when
        taxiPartyRepository.addTaxiParty(taxiParty, user: user)
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
        let taxiParty: TaxiParty = TaxiParty(id: "99E12FAF-3899-4131-99CD-4D054DA98289", departureCode: 0, destinationCode: 1, meetingDate: 0, meetingTime: 0, maxPersonNumber: 0, members: ["테스트 아이디"], isClosed: false)
        let user: User = User(id: "테스트 유저3", nickname: "하이", profileImage: "")
        var error: Error?
        // when
        taxiPartyRepository.joinTaxiParty(in: taxiParty, user: user)
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
