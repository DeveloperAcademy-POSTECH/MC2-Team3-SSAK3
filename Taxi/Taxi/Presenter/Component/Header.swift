//
//  TabTitle.swift
//  Taxi
//
//  Created by 민채호 on 2022/09/14.
//

import SwiftUI

struct Header: View {
    private let tab: Tab
    private let action: (() -> Void)?

    init(_ tab: Tab) {
        self.tab = tab
        self.action = nil
    }

    init(_ tab: Tab, action: @escaping () -> Void) {
        self.tab = tab
        self.action = action
    }

    var body: some View {
        HStack(alignment: .center) {
            Text(tab.title)
                .font(.custom("AppleSDGothicNeo-Bold", size: 25))
            Spacer()
            if let action = action {
                Button {
                    action()
                } label: {
                    Image(systemName: tab.image)
                        .imageScale(.large)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 19)
    }
}
