//
//  UserRepository.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/05.
//

import Combine
import Foundation

protocol UserRepository {
    func setUser(_ id: String, _ nickname: String) -> AnyPublisher<User, Error>
    func getUser(_ id: String) -> AnyPublisher<User, Error>
    func updateProfileImage(_ user: User, _ imageUrl: String) -> AnyPublisher<User, Error>
    func updateNickname(_ user: User, _ nickname: String) -> AnyPublisher<User, Error>
}
