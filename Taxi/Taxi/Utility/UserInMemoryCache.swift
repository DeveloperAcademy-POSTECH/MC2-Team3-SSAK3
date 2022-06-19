//
//  UserInMemoryCache.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/19.
//

import Foundation

final class UserInMemoryCache {
    static let shared: UserInMemoryCache = UserInMemoryCache()
    private var cache: [String: User] = [:]
    private init() {}

    func getUser(_ id: String) -> User? {
        cache[id]
    }

    func saveUser(_ user: User) {
        cache[user.id] = user
    }
}
