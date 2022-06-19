//
//  AppState.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/18.
//

import SwiftUI

final class AppState: ObservableObject {
    @Published var tab: Tab = .taxiParty
    @Published var showChattingRoom: Bool = false
    var currentTaxiParty: TaxiParty?

    func showChattingRoom(_ taxiParty: TaxiParty) {
        tab = .myParty
        currentTaxiParty = taxiParty
        showChattingRoom = true
    }
}
