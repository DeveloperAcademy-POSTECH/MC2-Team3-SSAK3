//
//  TaxiPartyRepository.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/07.
//

import Combine
import Foundation

protocol TaxiPartyRepository {

    /// 현재 모집중인 택시팟을 가져오는 함수
    /// - Parameter id: 제외할 id -> nil 이면 모든 택시파티를 전부 불러온다.
    /// - Parameter load: 강제로 최신화할지 여부 -> false 이면 cache 에서 불러온다.
    /// - Returns: 현재 모집중인 택시파티
    func getTaxiParty(exclude id: String?, force load: Bool) -> AnyPublisher<[TaxiParty], Error>

    /// 택시팟을 추가하는 함수
    /// - Parameter taxiParty: 추가할 택시파티
    /// - Returns: TaxiParty 혹은 Error 를 발행하는 Publisher
    func addTaxiParty(_ taxiParty: TaxiParty, user: User) -> AnyPublisher<TaxiParty, Error>

    /// 택시파티에 참가하는 함수
    /// - Parameter taxiParty: 참가할 택시파티
    /// - Returns: TaxParty 혹은 Error 를 발행하는 Publihser
    func joinTaxiParty(in taxiParty: TaxiParty, user: User) -> AnyPublisher<TaxiParty, Error>
}
