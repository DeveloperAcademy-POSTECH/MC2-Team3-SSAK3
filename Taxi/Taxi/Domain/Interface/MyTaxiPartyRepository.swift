//
//  MyTaxiPartyRepository.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/08.
//

import Combine
import Foundation

protocol MyTaxiPartyRepository {

    /// 내가 참가한 택시파티를  불러오는 함수
    /// - Parameter user: 나
    /// - Returns: 내가 참가한 택시파티 리스트
    func getMyTaxiParty(of user: User) -> AnyPublisher<[TaxiParty], Error>

    /// 참가한 택시파티를 떠나는 함수
    /// - Parameter taxiParty: 참가한 택시파티
    /// - Returns: Error 를 발행하는 Publisher
    func leaveTaxiParty(_ taxiParty: TaxiParty) -> AnyPublisher<Void, Error>
}
