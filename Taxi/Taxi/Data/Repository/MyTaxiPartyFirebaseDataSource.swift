//
//  MyTaxiPartyFirebaseDataSource.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/08.
//

import Combine
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift

final class MyTaxiPartyFirebaseSource: MyTaxiPartyRepository {

    static let shared = MyTaxiPartyFirebaseSource()
    private let fireStore: Firestore = Firestore.firestore()
    private let chattingUseCase: ChattingUseCase = ChattingUseCase.shared
    private init() {}
    private var collectionName: String {
        if ProcessInfo().isRunningTests {
            return "TaxiParty"
        } else {
            return "TaxiParty"
        }
    }

    func getMyTaxiParty(of userId: String, force load: Bool = false) -> AnyPublisher<[TaxiParty], Error> {
        fireStore.collection(collectionName)
            .whereField("members", arrayContains: userId)
            .getDocuments(source: load ? .server: .cache)
            .map(\.documents)
            .tryMap { documents -> [TaxiParty] in
                var ret: [TaxiParty] = []
                for document in documents {
                    try ret.append(document.data(as: TaxiParty.self))
                }
                return ret
            }
            .map { taxiParties in
                taxiParties.sorted { firstParty, secondParty in
                    if firstParty.meetingDate < secondParty.meetingDate {
                        return true
                    } else if firstParty.meetingDate == secondParty.meetingDate {
                        return firstParty.meetingTime < secondParty.meetingTime
                    } else {
                        return false
                    }
                }
            }
            .eraseToAnyPublisher()
    }

    func leaveTaxiParty(_ taxiParty: TaxiParty, user: UserInfo) -> AnyPublisher<Void, Error> {
        fireStore.collection(collectionName).document(taxiParty.id)
            .updateData([
                "members": FieldValue.arrayRemove([user.id])
            ])
            .flatMap { [weak self] () -> (AnyPublisher<Void, Error>) in
                guard let self = self else {
                    return Fail<Void, Error>(error: FirestoreDecodingError.decodingIsNotSupported(""))
                        .eraseToAnyPublisher()
                }
                let message: Message = Message(sender: user.id, body: "\(user.nickname)님이 택시팟에서 나가셨습니다.", messageType: .entrance)
                return self.chattingUseCase.sendMessage(message, to: taxiParty)
            }
            .eraseToAnyPublisher()
    }
}
