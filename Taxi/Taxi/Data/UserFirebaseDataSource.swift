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
import FirebaseStorage
import FirebaseStorageCombineSwift

final class UserFirebaseDataSource: UserRepository {

    private let fireStore: Firestore = .firestore()
    private let storage: Storage = Storage.storage()

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

    func updateProfileImage(_ user: User, _ imageData: Data) -> AnyPublisher<User, Error> {

        let storageRef = storage.reference()
        let ref = storageRef.child("ProfileImage/\(user.id)Profile.jpg")
        let docRef = fireStore.collection("User").document(user.id)
        var downloadUrl: String?
        let metaData: StorageMetadata = StorageMetadata()
        metaData.cacheControl = "public,max-age=300"
        metaData.contentType = "image/jpeg"
        print("upload file")
        return Future<String, Error> { promise in
            ref.putData(imageData, metadata: metaData) { _, error in
                print("put file")
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
            User(id: user.id, nickname: user.nickname, profileImage: downloadUrl)
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
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
