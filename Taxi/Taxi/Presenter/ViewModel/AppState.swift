//
//  AppState.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/18.
//

import SwiftUI

final class AppState: ObservableObject {
    @Published private (set) var tab: Tab = .taxiParty
    @Published private (set) var showChattingRoom: Bool = false
    private (set) var currentTaxiParty: TaxiParty?

    func showChattingRoom(_ taxiParty: TaxiParty) {
        tab = .myParty
        currentTaxiParty = taxiParty
        showChattingRoom = true
    }
}
