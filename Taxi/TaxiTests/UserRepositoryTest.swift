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
        userRepository = UserFirebaseDataSource.shared
        cancelBag = []
    }

    override func tearDownWithError() throws {
        userRepository = nil
        cancelBag = nil
        try super.tearDownWithError()
    }

    /// 회원가입 함수를 테스트하는 코드
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

    /// 회원정보 로딩 함수를 테스트하는 코드
    func testGetUser() {
        // given
        var user: User?
        let promise = expectation(description: "User should exist")

        // when
        userRepository
            .getUser("1", force: true)
            .sink { _ in
                promise.fulfill()
            } receiveValue: {
                user = $0
            }.store(in: &cancelBag)

        wait(for: [promise], timeout: 5)
        XCTAssertNotNil(user)
    }

    /// 없는 유저의 닉네임을 변경할 경우 에러가 뜨는지 테스트하는 코드
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

    /// 닉네임 업데이트 함수를 테스트하는 코드
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

    /// 프로필 이미지 업데이트 함수를 테스트하는 코드
    func testUpdateProfileImage() {
        // given
        var error: Error?
        let promise = expectation(description: "Update profile image succeed")
        let testBundle: Bundle = Bundle(for: type(of: self))
        guard let data = try? Data(contentsOf: testBundle.url(forResource: "1Profile", withExtension: "jpg")!) else {
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
