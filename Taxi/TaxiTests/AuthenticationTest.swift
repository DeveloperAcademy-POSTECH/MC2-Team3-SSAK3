//
//  AuthenticationTest.swift
//  TaxiTests
//
//  Created by JongHo Park on 2022/06/01.
//

@testable import Taxi
import XCTest

class AuthenticationTest: XCTestCase {
    var authentication: Authentication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        authentication = Authentication()
    }

    override func tearDownWithError() throws {
        authentication = nil
        try super.tearDownWithError()
    }

    func testSendSignInEmailToDeveloper() throws {
        // given
        let promise = expectation(description: "Send SignInLink Email Successfully")
        var error: Error?

        // when
        authentication.sendSignInEmail(to: "pjh00098@gmail.com") {
            error = $0
            promise.fulfill()
        }

        // then
        wait(for: [promise], timeout: 5)
        XCTAssertNil(error)
    }
}
