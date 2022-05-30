//
//  TaxiApp.swift
//  Taxi
//
//  Created by JongHo Park on 2022/05/27.
//

import Firebase
import SwiftUI

@main
struct TaxiApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
