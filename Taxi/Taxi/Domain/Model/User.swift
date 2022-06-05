//
//  User.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/04.
//

import Foundation

struct User: Codable {
    let id: String // 기기 고유의 uuid 를 사용해 유저를 식별한다.
    let nickName: String // 유저 닉네임
    let profileImage: String? // 프로필 이미지
}

extension User: CustomStringConvertible {
    var description: String {
        "유저 닉네임: \(nickName) 프로필 이미지 url: \(profileImage ?? "없음")"
    }
}
