//
//  ChattingViewModel.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/15.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift

final class ChattingViewModel: ObservableObject {
    @Published private (set) var messages: [Message] = []
    private let fireStore: Firestore = .firestore()
    private let taxiParty: TaxiParty
    private let chattingUseCase: ChattingUseCase = ChattingUseCase()
    private var listenerRegistration: ListenerRegistration?

    init(_ taxiParty: TaxiParty) {
        self.taxiParty = taxiParty
    }

    func sendMessage(_ userId: String, body: String, completion: @escaping (Error?) -> Void) {
        let message: Message = Message(id: UUID().uuidString, sender: userId, body: body, timeStamp: Date().messageTime, typeCode: Message.MessageType.normal.code)
        chattingUseCase.sendMessage(message, to: taxiParty, completion: completion)
    }

    func setMessageChangeListener() {
        listenerRegistration = fireStore.collection("TaxiParty")
            .document(taxiParty.id)
            .collection("messages")
            .order(by: "timeStamp")
            .addSnapshotListener({ [weak self] snapshot, error in
                guard let self = self, error == nil, let snapshot = snapshot else {
                    return
                }
                var messagesToAppend: [Message] = []
                snapshot.documentChanges.forEach { diff in
                    if diff.type == .added, let message: Message = try? diff.document.data(as: Message.self) {
                        messagesToAppend.append(message)
                    }
                }
                self.messages.append(contentsOf: messagesToAppend)
            })
    }

    func removeMessageChangeListener() {
        listenerRegistration?.remove()
    }

    deinit {
        listenerRegistration?.remove()
    }
}
