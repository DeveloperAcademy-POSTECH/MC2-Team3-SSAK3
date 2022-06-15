//
//  ChattingRepository.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/15.
//

import Combine

protocol ChattingRepository {
    func sendMessage(_ message: Message, to taxiParty: TaxiParty) -> AnyPublisher<Void, Error>
}
