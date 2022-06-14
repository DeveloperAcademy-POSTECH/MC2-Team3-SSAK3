//
//  AddTaxiParty.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/14.
//

import SwiftUI

// MARK: - 정보를 입력하는 각 단계를 지칭하는 enumeration
extension AddTaxiParty {
    enum Step {
        case none
        case destination
        case date
        case time
        case departure
        case personNumber
    }
}
struct AddTaxiParty: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AddTaxiParty_Previews: PreviewProvider {
    static var previews: some View {
        AddTaxiParty()
    }
}
