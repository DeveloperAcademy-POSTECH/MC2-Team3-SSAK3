//
//  ChattingUseCase.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/15.
//

import Combine

final class ChattingUseCase {
    private let chattingRepository: ChattingRepository
    private var cancelBag: Set<AnyCancellable> = []

    init(_ chattingRepository: ChattingRepository = ChattingFirebaseDataSource.shared) {
        self.chattingRepository = chattingRepository
    }

    func sendMessage(_ message: Message, to taxiParty: TaxiParty) -> AnyPublisher<Void, Error> {
        return chattingRepository.sendMessage(message, to: taxiParty)
    }

    func sendMessage(_ message: Message, to taxiParty: TaxiParty, completion: @escaping (Error?) -> Void) {
        chattingRepository.sendMessage(message, to: taxiParty)
            .sink { result in
                switch result {
                case .failure(let error):
                    completion(error)
                case .finished:
                    completion(nil)
                }
            } receiveValue: { _ in }
            .store(in: &cancelBag)
    }
}
