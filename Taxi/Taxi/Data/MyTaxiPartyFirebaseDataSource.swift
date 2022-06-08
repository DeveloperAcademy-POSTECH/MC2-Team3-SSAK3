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
    private init() {}

    func getMyTaxiParty(of user: User, force load: Bool = false) -> AnyPublisher<[TaxiParty], Error> {
        fireStore.collection("TaxiParty")
            .whereField("members", arrayContains: user.id)
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
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func leaveTaxiParty(_ taxiParty: TaxiParty, user: User) -> AnyPublisher<Void, Error> {
        fireStore.collection("TaxiParty").document(taxiParty.id)
            .updateData([
                "members": FieldValue.arrayRemove([user.id])
            ])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
