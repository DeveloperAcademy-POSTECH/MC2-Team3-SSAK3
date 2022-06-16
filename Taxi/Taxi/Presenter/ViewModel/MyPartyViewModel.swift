//
//  MyPartyViewModel.swift
//  Taxi
//
//  Created by 이윤영 on 2022/06/15.
//

import Foundation

 final class MyPartyViewModel: ObservableObject {
     @Published private (set) var myPartyList: [TaxiParty] = []
     private let myPartyUseCase: MyTaxiPartyUseCase = MyTaxiPartyUseCase()

     func getMyParties(user: User) {
         myPartyUseCase.getMyTaxiParty(user, force: true) { [weak self] taxiParties, error in
             guard let self = self, let taxiParties = taxiParties, error == nil else {
                 print(error!)
                 return
             }
             self.myPartyList = taxiParties
         }
     }

     func leaveMyParty(user: User, party: TaxiParty) {
         myPartyUseCase.leaveTaxiParty(party, user: user) { [weak self] error in
             guard let self = self, error == nil else {
                 print(error!)
                 return
             }
             self.deletePartyInList(party: party)
         }
     }

     private func deletePartyInList(party: TaxiParty) {
         if let index = self.myPartyList.firstIndex(of: party) {
             self.myPartyList.remove(at: index)
         }
     }
 }
