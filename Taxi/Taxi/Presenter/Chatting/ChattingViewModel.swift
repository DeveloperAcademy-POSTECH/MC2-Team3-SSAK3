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

    // MARK: - States
    @Published private (set) var messages: [Message] = []
    @Published var input: String = ""
    @Published private (set) var taxiParty: TaxiParty

    // MARK: - Dependency
    private let fireStore: Firestore = .firestore()
    private let chattingUseCase: ChattingUseCase = ChattingUseCase.shared
    private var messageListenerRegistration: ListenerRegistration?
    private var taxiPartyListenerRegistration: ListenerRegistration?
    let updateEvent: PassthroughSubject<Bool, Never> = PassthroughSubject()

    init(_ taxiParty: TaxiParty) {
        self.taxiParty = taxiParty
    }

    func sendMessage(_ userId: String) {
        guard !input.isEmpty else {
            return
        }
        let message: Message = Message(sender: userId, body: input, messageType: .normal)
        input = ""
        chattingUseCase.sendMessage(message, to: taxiParty, completion: { _ in })
    }

    func onAppear() {
        setMessageChangeListener()
        setTaxiPartyChangeListener()
    }

    func onDisAppear() {
        removeChangeListener()
    }
}

// MARK: - 내부 구현
private extension ChattingViewModel {
    func setTaxiPartyChangeListener() {
        taxiPartyListenerRegistration = fireStore.collection("TaxiParty")
            .document(taxiParty.id)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self, error == nil, let snapshot = snapshot else { return }
                guard let changedTaxiParty = try? snapshot.data(as: TaxiParty.self) else { return }
                DispatchQueue.main.async {
                    self.taxiParty = changedTaxiParty
                }
            }
    }

    func setMessageChangeListener() {
        messageListenerRegistration = fireStore.collection("TaxiParty")
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
                DispatchQueue.main.async {
                    self.messages.append(contentsOf: messagesToAppend)
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                    self.updateEvent.send(true)
                }
            })
    }

    func removeChangeListener() {
        messageListenerRegistration?.remove()
        taxiPartyListenerRegistration?.remove()
        messages.removeAll()
    }
}
