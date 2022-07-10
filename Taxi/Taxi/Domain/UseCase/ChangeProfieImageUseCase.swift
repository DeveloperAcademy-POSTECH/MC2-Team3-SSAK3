//
//  ChangeProfieImageUseCase.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/10.
//

import Combine
import Foundation

final class ChangeProfileImageUseCase {
    private let userRepository: UserRepository
    private var cancelBag: Set<AnyCancellable> = []

    init(userRepository: UserRepository = UserFirebaseDataSource.shared) {
        self.userRepository = userRepository
    }

    /// 프로필 이미지를 업데이트하는 함수, 이미지 업데이트 성공 시 이미지 url 이 변경된 User 정보를 반환한다.
    /// - Parameters:
    ///   - user: 이미지를 변경할 유저
    ///   - imageData: 이미지 데이터, Image 를 data 로 변환해 매개변수로 넘겨야 한다. 또한 이미지의 용량에 주의하도록 하자. 만약 용량이 너무 큰 이미지라면 UIImage 에서 지원해주는 decompression 을 거친 후 넘겨주자
    /// - Returns: User 혹은 Error 를 발행하는 Publisher
    func changeProfileImage(_ user: UserInfo, to imageData: Data) -> AnyPublisher<UserInfo, Error> {
        return userRepository.updateProfileImage(user, imageData)
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
}
