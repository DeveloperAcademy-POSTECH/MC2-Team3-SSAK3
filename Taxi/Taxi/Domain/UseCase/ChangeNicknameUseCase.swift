//
//  ChangeNicknameUseCase.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/10.
//

import Combine
import Foundation

final class ChangeNicknameUseCase {

    private let userRepository: UserRepository
    private var cancelBag: Set<AnyCancellable> = []

    init(_ userRepository: UserRepository = UserFirebaseDataSource.shared) {
        self.userRepository = userRepository
    }
    /// 닉네임을 변경하는 함수, 닉네임 변경 성공 시 닉네임이 변경된 User 정보를 반환한다.
    /// - Parameters:
    ///   - user: 닉네임을 변경할 유저
    ///   - nickname: 변경할 닉네임
    /// - Returns: User 혹은 Error 를 발행하는 Publisher
    func changeNickname(_ user: UserInfo, to nickname: String) -> AnyPublisher<UserInfo, Error> {
        return userRepository.updateNickname(user, nickname)
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
}
