//
//  AuthenticateUseCase.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/10.
//

import Combine
import Foundation

final class DeleteProfileImageUseCase {
    private let userRepository: UserRepository
    private var cancelBag: Set<AnyCancellable> = []

    init(_ userRepository: UserRepository = UserFirebaseDataSource.shared) {
        self.userRepository = userRepository
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
