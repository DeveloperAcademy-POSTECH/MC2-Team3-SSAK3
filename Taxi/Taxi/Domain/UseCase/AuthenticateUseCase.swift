//
//  AuthenticateUseCase.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/10.
//

import Combine
import Foundation

final class AuthenticateUseCase {
    private let userRepository: UserRepository
    private var cancelBag: Set<AnyCancellable> = []

    init(_ userRepository: UserRepository = UserFirebaseDataSource.shared) {
        self.userRepository = userRepository
    }

    /// 기기 고유아이디로 로그인 요청 시 해당 User 정보를 반환하는 함수
    /// - Parameter id: 기기 고유아이디
    /// - Returns: User 혹은 Error 를 발행하는 Publisher
    func login(_ id: String, force load: Bool = false) -> AnyPublisher<UserInfo, Error> {
        return userRepository.getUser(id, force: load)
    }

    /// 닉네임을 변경하는 함수, 닉네임 변경 성공 시 닉네임이 변경된 User 정보를 반환한다.
    /// - Parameters:
    ///   - user: 닉네임을 변경할 유저
    ///   - nickname: 변경할 닉네임
    /// - Returns: User 혹은 Error 를 발행하는 Publisher
    func changeNickname(_ user: UserInfo, to nickname: String) -> AnyPublisher<UserInfo, Error> {
        return userRepository.updateNickname(user, nickname)
    }

    /// 프로필 이미지를 업데이트하는 함수, 이미지 업데이트 성공 시 이미지 url 이 변경된 User 정보를 반환한다.
    /// - Parameters:
    ///   - user: 이미지를 변경할 유저
    ///   - imageData: 이미지 데이터, Image 를 data 로 변환해 매개변수로 넘겨야 한다. 또한 이미지의 용량에 주의하도록 하자. 만약 용량이 너무 큰 이미지라면 UIImage 에서 지원해주는 decompression 을 거친 후 넘겨주자
    /// - Returns: User 혹은 Error 를 발행하는 Publisher
    func changeProfileImage(_ user: UserInfo, to imageData: Data) -> AnyPublisher<UserInfo, Error> {
        return userRepository.updateProfileImage(user, imageData)
    }

    /// 회원가입을 시도하는 함수, 회원가입 성공 시 해당 회원 정보를 반환한다.
    /// - Parameters:
    ///   - id: 기기 고유아이디
    ///   - nickname: 초기 닉네임
    /// - Returns: User 혹은 Error 를 발행하는 Publisher
    func register(_ id: String, _ nickname: String) -> AnyPublisher<UserInfo, Error> {
        return userRepository.setUser(id, nickname)
    }

    func login(_ id: String, force load: Bool = false, completion: @escaping (UserInfo?, Error?) -> Void) {
        userRepository.getUser(id, force: load)
            .sink { result in
                if case let .failure(error) = result {
                    completion(nil, error)
                }
            } receiveValue: { user in
                completion(user, nil)
            }.store(in: &cancelBag)
    }

    func changeNickname(_ user: UserInfo, to nickname: String, completion: @escaping (UserInfo?, Error?) -> Void) {
        userRepository.updateNickname(user, nickname)
            .sink { result in
                if case let .failure(error) = result {
                    completion(nil, error)
                }
            } receiveValue: { user in
                completion(user, nil)
            }.store(in: &cancelBag)
    }

    func changeProfileImage(_ user: UserInfo, to imageData: Data, completion: @escaping (UserInfo?, Error?) -> Void) {
        userRepository.updateProfileImage(user, imageData)
            .sink { result in
                if case let .failure(error) = result {
                    completion(nil, error)
                }
            } receiveValue: { user in
                completion(user, nil)
            }.store(in: &cancelBag)
    }

    func register(_ id: String, _ nickname: String, completion: @escaping (UserInfo?, Error?) -> Void) {
        userRepository.setUser(id, nickname)
            .sink { result in
                if case let .failure(error) = result {
                    completion(nil, error)
                }
            } receiveValue: { user in
                completion(user, nil)
            }.store(in: &cancelBag)
    }

    func deleteProfileImage(for user: UserInfo) -> AnyPublisher<UserInfo, Error> {
        return userRepository.deleteProfileImage(for: user)
    }

    func deleteProfileImage(for user: UserInfo, completion: @escaping (UserInfo?, Error?) -> Void) {
        userRepository.deleteProfileImage(for: user)
            .sink { result in
                if case let .failure(error) = result {
                    completion(nil, error)
                }
            } receiveValue: { user in
                completion(user, nil)
            }.store(in: &cancelBag)
    }
}
