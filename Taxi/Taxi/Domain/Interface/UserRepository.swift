//
//  UserRepository.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/05.
//

import Combine
import Foundation

typealias Email = String

protocol UserRepository {

    /// 회원가입 시 호출하는 함수
    /// - Parameters:
    ///   - id: 유저의 고유 아이디 -> 현재 단계에선 디바이스 고유 uuid 를 추천한다.
    ///   - nickname: 유저의 닉네임
    /// - Returns: User 혹은 Error 를 발행하는 Publisher, 회원가입에 성공하면 User 를, 실패하면 Error 를 반환한다.
    func setUser(_ id: String, _ nickname: String) -> AnyPublisher<UserInfo, Error>

    /// 회원정보를 가져오는 함수
    /// - Parameter id: 유저의 고유 아이디 -> 고유 아이디를 기반으로 유저 정보를 가져온다
    /// - Returns: User 혹은 Error 를 발행하는 Publisher
    func getUser(_ id: String, force load: Bool) -> AnyPublisher<UserInfo, Error>

    /// 프로필 이미지를 업데이트 하는 함수
    /// - Parameters:
    ///   - user: 프로필 이미지를 업데이트할 유저
    ///   - imageData: 프로필 이미지 데이터 -> 용량 제한을 둬야 한다.
    /// - Returns: User 혹은 Error 를 발행하는 Publisher, 프로필 이미지 업데이트에 성공하면 User, 실패하면 Error 를 반환한다.
    func updateProfileImage(_ user: UserInfo, _ imageData: Data) -> AnyPublisher<UserInfo, Error>

    /// 닉네임을 업데이트 하는 함수
    /// - Parameters:
    ///   - user: 닉네임을 업데이트할 유저
    ///   - nickname: 업데이트 할 닉네임
    /// - Returns: User 혹은 Error 를 발행하는 Publisher, 업데이트에 성공하면 User 를, 실패하면 Error 를 반환한다.
    func updateNickname(_ user: UserInfo, _ nickname: String) -> AnyPublisher<UserInfo, Error>

    /// 프로필 이미지를 삭제하는 함수
    /// - Parameter user: 프로필 이미지를 삭제할 유저
    /// - Returns: User 혹은 Error 를 발행하는 Publisher, 업데이트에 성공하면 User 를, 실패하면 Error 를 반환한다.
    func deleteProfileImage(for user: UserInfo) -> AnyPublisher<UserInfo, Error>


    /// 인증 이메일을 보내는 함수
    /// - Parameter email: 인증 이메일을 보낼 이메일
    /// - Returns: 전송 성공 여부
    func sendSignInEmail(to email: Email) -> AnyPublisher<Void, Error>
}
