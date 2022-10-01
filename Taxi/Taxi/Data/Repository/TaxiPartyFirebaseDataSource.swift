//
//  TaxiPartyFirebaseDataSource.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/07.
//

import Combine
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import FirebaseFunctions
import FirebaseFunctionsCombineSwift

final class TaxiPartyFirebaseDataSource: TaxiPartyRepository {

    private let fireStore: Firestore = .firestore()
    private let functions: Functions = Functions.functions()
    private let chattingUseCase: ChattingUseCase = ChattingUseCase.shared
    static let shared: TaxiPartyRepository = TaxiPartyFirebaseDataSource()

    private init() {}

    func getTaxiParty(exclude id: String?, force load: Bool) -> AnyPublisher<[TaxiParty], Error> {
        let date = Date()
        let day = date.formattedInt!

        return fireStore.collection("TaxiParty")
            .whereField("meetingDate", isGreaterThanOrEqualTo: day)
            .getDocuments(source: load ? .server: .cache)
            .map(\.documents)
            .tryMap { documents -> [TaxiParty] in
                var ret: [TaxiParty] = []
                for document in documents {
                    let taxiParty: TaxiParty = try document.data(as: TaxiParty.self)
                    if !taxiParty.isParticipating(id: id ?? "") && taxiParty.isNotEmpty() {
                        ret.append(taxiParty)
                    }
                }
                return ret
            }
            .map({ taxiParties in
                taxiParties.sorted { firstParty, secondParty in
                    if firstParty.meetingDate < secondParty.meetingDate {
                        return true
                    } else if firstParty.meetingDate == secondParty.meetingDate {
                        return firstParty.meetingTime < secondParty.meetingTime
                    } else {
                        return false
                    }
                }
            })
            .map(filterPassedTaxiParty(_:))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func addTaxiParty(_ taxiParty: TaxiParty, user: UserInfo) -> AnyPublisher<TaxiParty, Error> {
        fireStore.collection("TaxiParty")
            .document(taxiParty.id)
            .setData(from: taxiParty)            
            .flatMap { [weak self] () -> (AnyPublisher<Void, Error>) in
                guard let self = self else {
                    return Fail<Void, Error>(error: FirestoreDecodingError.decodingIsNotSupported(""))
                        .eraseToAnyPublisher()
                }
                let message: Message = Message(sender: user.id, body: "\(user.nickname)님이 택시팟에 참가했습니다.", messageType: .entrance)
                return self.chattingUseCase.sendMessage(message, to: taxiParty)
            }
            .map {
                taxiParty
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func joinTaxiParty(in taxiParty: TaxiParty, user: UserInfo) -> AnyPublisher<TaxiParty, Error> {
        return functions.httpsCallable("joinTaxiParty").call([
            "taxiPartyId": taxiParty.id,
            "userId": user.id
        ])
        .flatMap { [weak self] (_) -> (AnyPublisher<Void, Error>) in
            guard let self = self else {
                return Fail<Void, Error>(error: FirestoreDecodingError.decodingIsNotSupported(""))
                    .eraseToAnyPublisher()
            }
            let message: Message = Message(sender: user.id, body: "\(user.nickname)님이 택시팟에 참가했습니다.", messageType: .entrance)
            return self.chattingUseCase.sendMessage(message, to: taxiParty)
        }
        .map {
            var updatedMembers: [String] = taxiParty.members
            updatedMembers.append(user.id)
            return TaxiParty(id: taxiParty.id, departureCode: taxiParty.departureCode, destinationCode: taxiParty.destinationCode, meetingDate: taxiParty.meetingDate, meetingTime: taxiParty.meetingTime, maxPersonNumber: taxiParty.maxPersonNumber, members: updatedMembers, isClosed: taxiParty.isClosed)
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

private extension TaxiPartyFirebaseDataSource {
    func filterPassedTaxiParty(_ parties: [TaxiParty]) -> [TaxiParty] {
        let date = Date()
        return parties.filter { party in
            if party.meetingDate == date.formattedInt {
                guard let hour = date.hour, let minute = date.minute else {
                    return true
                }
                let compareTime = hour * 100 + minute

                return party.meetingTime >= compareTime
            }
            return true
        }
    }
}
