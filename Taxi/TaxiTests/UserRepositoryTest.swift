//
//  UserRepositoryTest.swift
//  TaxiTests
//
//  Created by JongHo Park on 2022/06/05.
//

import Combine
@testable import Taxi
import XCTest

class UserRepositoryTest: XCTestCase {

    private var userRepository: UserRepository!
    private var cancelBag: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        userRepository = UserFirebaseDataSource()
        cancelBag = []
    }

    override func tearDownWithError() throws {
        userRepository = nil
        cancelBag = nil
        try super.tearDownWithError()
    }

    func testSetUser() {
        // given
        var error: Error?
        let promise = expectation(description: "Error should not exist")

        // when
        userRepository
            .setUser("1", "호종이")
            .sink { completion in
                switch completion {
                case .failure(let err):
                    error = err
                default:
                    print("unknown result")
                }
                promise.fulfill()
            } receiveValue: { user in
                print(user)
            }.store(in: &cancelBag)

        // then
        wait(for: [promise], timeout: 0.5)
        XCTAssertNil(error)
    }

    func testGetUser() {
        // given
        var user: User?
        let promise = expectation(description: "User should exist")

        // when
        userRepository
            .getUser("1")
            .sink { _ in
                promise.fulfill()
            } receiveValue: {
                user = $0
            }.store(in: &cancelBag)

        wait(for: [promise], timeout: 1)
        XCTAssertNotNil(user)
    }
}
