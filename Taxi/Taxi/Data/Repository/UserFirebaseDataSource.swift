//
//  UserFirebaseDataSource.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/05.
//

import Combine
import Foundation
import FirebaseAuth
import FirebaseAuthCombineSwift
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import FirebaseStorage
import FirebaseStorageCombineSwift

final class UserFirebaseDataSource: UserRepository {

    private let fireStore: Firestore = .firestore()
    private let storage: Storage = Storage.storage()
    private let cache: UserInMemoryCache = UserInMemoryCache.shared
    static let shared: UserRepository = UserFirebaseDataSource()

    private init() {}

    func setUser(_ id: String, _ nickname: String) -> AnyPublisher<UserInfo, Error> {
        let user: UserInfo = UserInfo(id: id, nickname: nickname, profileImage: nil)
        return fireStore.collection("User").document(id).setData(from: user)
            .map { user }
            .eraseToAnyPublisher()
    }

    func getUser(_ id: String, force load: Bool) -> AnyPublisher<UserInfo, Error> {
        func returnPublisher() -> AnyPublisher<UserInfo, Error> {
            let docRef = fireStore.collection("User").document(id)
            return Future<UserInfo, Error> { promise in
                docRef.getDocument { [weak self] result, error in
                    guard let user = try? result?.data(as: UserInfo.self), let self = self else {
                        if let error = error {
                            promise(Result.failure(error))
                        }
                        return
                    }
                    self.cache.saveUser(user)
                    promise(Result.success(user))
                }
            }
            .eraseToAnyPublisher()
        }
        // 서버에서 유저를 불러와야할 때
        if load {
            return returnPublisher()
        }
        // 강제로 서버를 활용할 필요가 없는 경우 가능한 캐시에서 유저를 불러온다.
        else {
            guard let user = cache.getUser(id) else {
                return returnPublisher()
            }
            return Just(user).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }

    func updateProfileImage(_ user: UserInfo, _ imageData: Data) -> AnyPublisher<UserInfo, Error> {

        let storageRef = storage.reference()
        let ref = storageRef.child("ProfileImage/\(user.id)Profile.jpg")
        let docRef = fireStore.collection("User").document(user.id)
        var downloadUrl: String?
        let metaData: StorageMetadata = StorageMetadata()
        metaData.cacheControl = "public,max-age=300"
        metaData.contentType = "image/jpeg"
        return Future<String, Error> { promise in
            ref.putData(imageData, metadata: metaData) { _, error in
                if let error = error {
                    print(error)
                    promise(.failure(error))
                    return
                }
                ref.downloadURL { (url, error) in
                    if let error = error {
                        promise(Result.failure(error))
                        return
                    }
                    guard let downloadURL = url else {
                        promise(Result.failure(StorageError.objectNotFound("download url not found")))
                        return
                    }
                    downloadUrl = downloadURL.absoluteString
                    promise(.success(downloadURL.absoluteString))
                }
            }
        }
        .flatMap { downloadUrl in
            docRef.updateData(["profileImage": downloadUrl])
        }
        .map {
            UserInfo(id: user.id, nickname: user.nickname, profileImage: downloadUrl)
        }
        .eraseToAnyPublisher()
    }

    func updateNickname(_ user: UserInfo, _ nickname: String) -> AnyPublisher<UserInfo, Error> {
        let docRef = fireStore.collection("User").document(user.id)

        return docRef.updateData([
            "nickname": nickname
        ])
        .map { _ in
            UserInfo(id: user.id, nickname: user.nickname, profileImage: user.profileImage)
        }
        .eraseToAnyPublisher()
    }

    func deleteProfileImage(for user: UserInfo) -> AnyPublisher<UserInfo, Error> {
        let docRef = fireStore.collection("User").document(user.id)

        return docRef.updateData([
            "profileImage": FieldValue.delete()
        ])
        .map {
            UserInfo(id: user.id, nickname: user.nickname, profileImage: nil)
        }
        .eraseToAnyPublisher()
    }

    func deleteUser(_ user: UserInfo) -> AnyPublisher<Void, Error> {
        let docRef = fireStore.collection("User").document(user.id)

        return docRef.delete().eraseToAnyPublisher()
    }
}
