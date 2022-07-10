//
//  GetUserInfoUseCase.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/10.
//

import Combine
import Foundation

final class GetUserInfoUseCase {
    private let userRepository: UserRepository
    private var cancelBag: Set<AnyCancellable> = []

    init(_ userRepository: UserRepository = UserFirebaseDataSource.shared) {
        self.userRepository = userRepository
    }

    /// 기기 고유아이디로 로그인 요청 시 해당 User 정보를 반환하는 함수
    /// - Parameter id: 기기 고유아이디
    /// - Returns: User 혹은 Error 를 발행하는 Publisher
    func getUserInfo(_ id: String, force load: Bool = false) -> AnyPublisher<UserInfo, Error> {
        return userRepository.getUser(id, force: load)
    }

    func getUserInfo(_ id: String, force load: Bool = false, completion: @escaping (UserInfo?, Error?) -> Void) {
        userRepository.getUser(id, force: load)
            .sink { result in
                if case let .failure(error) = result {
                    completion(nil, error)
                }
            } receiveValue: { user in
                completion(user, nil)
            }.store(in: &cancelBag)
    }

}
