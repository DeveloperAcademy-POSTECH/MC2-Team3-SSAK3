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
    @Published var input: String = ""
    private let fireStore: Firestore = .firestore()
    private let taxiParty: TaxiParty
    private let chattingUseCase: ChattingUseCase = ChattingUseCase.shared
    private var listenerRegistration: ListenerRegistration?
    let updateEvent: PassthroughSubject<Bool, Never> = PassthroughSubject()

    init(_ taxiParty: TaxiParty) {
        self.taxiParty = taxiParty
    }

    func sendMessage(_ userId: String) {
        guard !input.isEmpty else {
            return
        }
        let message: Message = Message(id: UUID().uuidString, sender: userId, body: input, timeStamp: Date().messageTime, typeCode: Message.MessageType.normal.code)
        input = ""
        chattingUseCase.sendMessage(message, to: taxiParty, completion: { _ in })
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
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                    self.updateEvent.send(true)
                }
            })
    }

    func removeMessageChangeListener() {
        listenerRegistration?.remove()
        messages.removeAll()
    }

    deinit {
        listenerRegistration?.remove()
    }
}
