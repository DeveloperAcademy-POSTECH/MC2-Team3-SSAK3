//
//  ChattingFirebaseDataSource.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/15.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift

final class ChattingFirebaseDataSource: ChattingRepository {

    static let shared: ChattingFirebaseDataSource = ChattingFirebaseDataSource()
    private let fireStore: Firestore = Firestore.firestore()

    private init() {}

    func sendMessage(_ message: Message, to taxiParty: TaxiParty) -> AnyPublisher<Void, Error> {
        fireStore.collection("TaxiParty").document(taxiParty.id)
            .collection("messages")
            .addDocument(from: message)
            .map { _ in }
            .eraseToAnyPublisher()
    }
}
