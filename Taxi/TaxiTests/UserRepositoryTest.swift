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
        wait(for: [promise], timeout: 5)
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

        wait(for: [promise], timeout: 5)
        XCTAssertNotNil(user)
    }

    func testNicknameChangeCauseErrorWhenInvalidIdGiven() {
        // given
        var error: Error?
        let promise = expectation(description: "User doesn`t exist")

        // when
        userRepository
            .updateNickname(User(id: "0", nickname: "HojongE", profileImage: nil), "haha!!")
            .sink { completion in
                switch completion {
                case .failure(let err):
                    error = err
                default:
                    print("There is no error")
                }
                promise.fulfill()
            } receiveValue: { _ in }.store(in: &cancelBag)

        // then
        wait(for: [promise], timeout: 5)
        XCTAssertNotNil(error)
    }

    func testNicknameChange() {
        // given
        var error: Error?
        let promise = expectation(description: "User nickname changed")

        // when
        userRepository
            .updateNickname(User(id: "1", nickname: "호종이", profileImage: nil), "레이몬드")
            .sink { completion in
                switch completion {
                case .failure(let err):
                    error = err
                default:
                    print("There is no error")
                }
                promise.fulfill()
            } receiveValue: { _ in }
            .store(in: &cancelBag)

        // then
        wait(for: [promise], timeout: 5)
        XCTAssertNil(error)
    }

    func testUpdateProfileImage() {
        // given
        var error: Error?
        let promise = expectation(description: "Update profile image succeed")
        let fileUrl: String = "file:///Users/jonghopark/Library/Developer/CoreSimulator/Devices/411A59B8-2371-4F06-95A4-FB215B13E603/data/Containers/Data/Application/7159A520-988A-4CFF-B776-94CB690059C1/tmp/67F5B591-A601-4FB2-9656-F1F0201DDBCE.jpeg"
        let bundle: Bundle = Bundle.allBundles.first { bundle in
            bundle.bundleURL.absoluteString.contains("Tests")
        }!
        guard let data = try? Data(contentsOf: bundle.url(forResource: "1Profile", withExtension: "jpg")!) else {
            XCTFail("data not exist")
            return
        }
        // when
        userRepository
            .updateProfileImage(User(id: "1", nickname: "호종이", profileImage: nil), data)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    error = err
                default:
                    print("Error not exist")
                }
                promise.fulfill()
            } receiveValue: { _ in }
            .store(in: &cancelBag)

        // then
        wait(for: [promise], timeout: 60)
        XCTAssertNil(error)
    }
}
