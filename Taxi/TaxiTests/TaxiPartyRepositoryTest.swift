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
    private var cancelBag: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        taxiPartyRepository = TaxiPartyFirebaseDataSource.shared
        cancelBag = []
    }

    override func tearDownWithError() throws {
        cancelBag = nil
        taxiPartyRepository = nil
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
        let user: UserInfo = UserInfo(id: "하이", nickname: "", profileImage: "")
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
        let user: UserInfo = UserInfo(id: "테스트 유저3", nickname: "하이", profileImage: "")
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

    func test_엄청많이_참가할때_정상적으로_참가되는지() throws {
        let promise = expectation(description: #function)
        let taxiParty: TaxiParty = TaxiParty(id: "TestID", departureCode: 0, destinationCode: 1, meetingDate: 20231111, meetingTime: 930, maxPersonNumber: 2, members: ["TestUser1"], isClosed: false)
        taxiPartyRepository.addTaxiParty(taxiParty, user: UserInfo(id: "123", nickname: "테스트유저", profileImage: nil))
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail(#function + " \(error.localizedDescription)")
                case .finished:
                    break
                }
                promise.fulfill()
            } receiveValue: { _ in }
            .store(in: &cancelBag)
        // 택시팟이 추가될 때 까지 기다림
        wait(for: [promise], timeout: 5)
        let promise2 = expectation(description: #function + " 택시팟에 모두 참가한다.")
        let usersToJoin: [UserInfo] = {
            var ret: [UserInfo] = []
            for index in 0...20 {
                ret.append(UserInfo(id: String(index), nickname: "테스트유저", profileImage: nil))
            }
            return ret
        }()
        Publishers.MergeMany(usersToJoin.map({ userInfo in
            taxiPartyRepository.joinTaxiParty(in: taxiParty, user: userInfo)
        }))
        .sink { completion in
            switch completion {
            case .failure(let error):
                print(error)
            case .finished:
                break
            }
            promise2.fulfill()
        } receiveValue: { _ in
        }
        .store(in: &cancelBag)
        // 택시팟에 모두 참가할 때 까지 기다림
        wait(for: [promise2], timeout: 10)
        let promise3 = expectation(description: #function)
        var taxiParties: [TaxiParty]?
        taxiPartyRepository.getTaxiParty(exclude: nil, force: true)
            .sink { _ in
                promise3.fulfill()
            } receiveValue: {
                taxiParties = $0
            }
            .store(in: &cancelBag)
        wait(for: [promise3], timeout: 5)
        guard let addedParty = taxiParties?.first(where: {
            $0.id == "TestID"
        }) else {
            XCTFail("Taxi Party는 존재해야 합니다.")
            return
        }
        XCTAssertEqual(2, addedParty.currentMemeberCount)
    }

}
