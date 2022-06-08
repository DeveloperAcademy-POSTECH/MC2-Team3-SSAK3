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

final class TaxiPartyFirebaseDataSource: TaxiPartyRepository {

    private let fireStore: Firestore = .firestore()
    static let shared: TaxiPartyRepository = TaxiPartyFirebaseDataSource()

    private init() {}

    func getTaxiParty(exclude id: String?, force load: Bool) -> AnyPublisher<[TaxiParty], Error> {
        fireStore.collection("TaxiParty")
            .whereField("isClosed", isEqualTo: false)
            .getDocuments(source: load ? .server: .cache)
            .map(\.documents)
            .tryMap { documents -> [TaxiParty] in
                var ret: [TaxiParty] = []
                for document in documents {
                    let taxiParty: TaxiParty = try document.data(as: TaxiParty.self)
                    if taxiParty.id != id {
                        ret.append(taxiParty)
                    }
                }
                return ret
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func addTaxiParty(_ taxiParty: TaxiParty) -> AnyPublisher<TaxiParty, Error> {
        fireStore.collection("TaxiParty")
            .document(taxiParty.id)
            .setData(from: taxiParty)
            .map {
                taxiParty
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func joinTaxiParty(to taxiParty: TaxiParty) -> AnyPublisher<TaxiParty, Error> {
        fireStore.collection("TaxiParty")
            .document(taxiParty.id)
            .setData(from: taxiParty)
            .map {
                taxiParty
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}
