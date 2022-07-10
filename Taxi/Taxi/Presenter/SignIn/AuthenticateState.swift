//
//  AuthenticateState.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/10.
//

enum AuthenticateState {
    case `init`
    case loading
    case loaded(UserInfo)
    case needToRegister(uid: String)
    case error(Error)
}
