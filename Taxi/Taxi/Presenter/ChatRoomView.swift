//
//  ChatRoomView.swift
//  Taxi
//
//  Created by 이윤영 on 2022/06/13.
//

import SwiftUI

struct ChatRoomView: View {
    let party: TaxiParty
    var body: some View {
        VStack {
            Text("\(party.description)")
            Text("채팅방")
        }
    }
}
