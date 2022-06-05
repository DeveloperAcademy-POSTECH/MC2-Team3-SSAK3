//
//  UserFirebaseDataSource.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/05.
//

import Combine
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift

final class UserFirebaseDataSource: UserRepository {

    private let fireStore: Firestore = .firestore()

    func setUser(_ id: String, _ nickname: String) -> AnyPublisher<User, Error> {
        let user: User = User(id: id, nickname: nickname, profileImage: nil)
        return fireStore.collection("User").document(id).setData(from: user)
            .map { user }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func getUser(_ id: String) -> AnyPublisher<User, Error> {
        let docRef = fireStore.collection("User").document(id)
        return Future<User, Error> { promise in
            docRef.getDocument(as: User.self) { result in
                switch result {
                case .success(let user):
                    promise(Result.success(user))
                case .failure(let error):
                    promise(Result.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    func updateProfileImage(_ user: User, _ imageUrl: String) -> AnyPublisher<User, Error> {
        // TODO: 프로필 이미지 업데이트 함수
        return getUser(user.id)
    }

    func updateNickname(_ user: User, _ nickname: String) -> AnyPublisher<User, Error> {
        let docRef = fireStore.collection("User").document(user.id)

        return docRef.updateData([
            "nickname": nickname
        ])
        .map { _ in
            User(id: user.id, nickname: user.nickname, profileImage: user.profileImage)
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

}
