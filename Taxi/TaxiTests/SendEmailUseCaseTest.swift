//
//  SendEmailUseCaseTest.swift
//  TaxiTests
//
//  Created by JongHo Park on 2022/07/03.
//

@testable import Taxi
import XCTest

final class SendEmailUseCaseTest: XCTestCase {

    private var useCase: SendEmailUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        useCase = SendEmailUseCase()
    }

    override func tearDownWithError() throws {
        useCase = nil
        try super.tearDownWithError()
    }

    func testSendEmail() {
        // given
        let promise = expectation(description: "Send email success!")
        var error: Error?
        // then
        useCase.sendEmail(to: "pjh00098@gmail.com") { err in
            error = err
            print(err)
            promise.fulfill()
        }
        // when
        wait(for: [promise], timeout: 5)
        XCTAssertNil(error)
    }
}
