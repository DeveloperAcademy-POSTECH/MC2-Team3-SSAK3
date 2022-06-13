//
//  AuthenticateUsecaseTest.swift
//  TaxiTests
//
//  Created by JongHo Park on 2022/06/13.
//

@testable import Taxi
import XCTest

class AuthenticateUsecaseTest: XCTestCase {
    private let authenticateUsecase: AuthenticateUseCase = AuthenticateUseCase()

    func testLoginCompletionHandler() {
        // given
        let promise = expectation(description: "Login Success!")
        var error: Error?
        let id: String = "1"
        // when
        authenticateUsecase.login(id) { user, err in
            error = err
            if let user = user {
                print(user)
            }
            promise.fulfill()
        }
        // then
        wait(for: [promise], timeout: 5)
        XCTAssertNil(error)
    }

    func testRegisterCompletionHandler() {
        // given
        let promise = expectation(description: "Register Success!")
        var error: Error?
        let id: String = "캐쉰캐샤"
        let nickname: String = "21 세비지"
        // when
        authenticateUsecase.register(id, nickname) { user, err in
            error = err
            if let user = user {
                print(user)
            }
            promise.fulfill()
        }
        // then
        wait(for: [promise], timeout: 5)
        XCTAssertNil(error)
    }

    func testNicknameUpdateCompletionHandler() {
        // given
        let promise = expectation(description: "nickname Update Success!")
        var error: Error?
        let user: User = User(id: "캐쉰캐샤", nickname: "21 세비지", profileImage: nil)
        let updatedNickname: String = "켄드릭 라마"
        // when
        authenticateUsecase.changeNickname(user, to: updatedNickname) { user, err in
            error = err
            if let user = user {
                print(user)
            }
            promise.fulfill()
        }
        // then
        wait(for: [promise], timeout: 5)
        XCTAssertNil(error)
    }

    func testProfileImageUploadCompletionHandler() {
        // given
        let promise = expectation(description: "profile Image upload Success!")
        var error: Error?
        let user: User = User(id: "캐쉰캐샤", nickname: "켄드릭 라마", profileImage: nil)
        let bundle: Bundle = Bundle(for: type(of: self))
        guard let data = try? Data(contentsOf: bundle.url(forResource: "1Profile", withExtension: "jpg")!) else {
            XCTFail("data not exist")
            return
        }
        // when
        authenticateUsecase.changeProfileImage(user, to: data) { user, err in
            error = err
            if let user = user {
                print(user)
            }
            promise.fulfill()
        }
        // then
        wait(for: [promise], timeout: 10)
        XCTAssertNil(error)

    }
}
