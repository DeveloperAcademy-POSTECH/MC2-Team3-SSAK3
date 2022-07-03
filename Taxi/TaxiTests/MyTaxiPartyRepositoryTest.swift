//
//  MyTaxiPartyRepositoryTest.swift
//  TaxiTests
//
//  Created by JongHo Park on 2022/06/08.
//

import Combine
@testable import Taxi
import XCTest

class MyTaxiPartyRepositoryTest: XCTestCase {

    private var myTaxiPartyRepository: MyTaxiPartyRepository!
    private var cancelBag: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        try super.setUpWithError()
        myTaxiPartyRepository = MyTaxiPartyFirebaseSource.shared
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testGetMyTaxiParty() throws {
        // given
        var error: Error?
        let promise = expectation(description: "Get My Taxi Party Success!")
        // when
        myTaxiPartyRepository.getMyTaxiParty(of: "테스트 아이디", force: true)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    error = err
                    print(err)
                default:
                    print("no error")
                }
                promise.fulfill()
            } receiveValue: { taxiParties in
                print(taxiParties)
            }.store(in: &cancelBag)

        // then
        wait(for: [promise], timeout: 5)
        XCTAssertNil(error)
    }

    func testLeaveTaxiParty() throws {
        // given
        var error: Error?
        let promise = expectation(description: "Leave Taxi Party Success!")
        // when
        let taxiParty: TaxiParty = TaxiParty(id: "테스트2", departureCode: 0, destinationCode: 1, meetingDate: 12, meetingTime: 12, maxPersonNumber: 4, members: ["테스트 아이디2"], isClosed: false)
        myTaxiPartyRepository.leaveTaxiParty(taxiParty, user: UserInfo(id: "테스트 아이디2", nickname: "", profileImage: nil))
            .sink { completion in
                switch completion {
                case .failure(let err):
                    error = err
                default:
                    print("no error")
                }
                promise.fulfill()
            } receiveValue: { _ in }.store(in: &cancelBag)
        // then
        wait(for: [promise], timeout: 5)
        XCTAssertNil(error)
    }

}
