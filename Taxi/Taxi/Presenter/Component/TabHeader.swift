//
//  TabTitle.swift
//  Taxi
//
//  Created by 민채호 on 2022/09/14.
//

import SwiftUI

struct TabHeader: View {
    private let tab: TabTitle
    private let toolbarItem: TabToolbarItem
    private let action: (() -> Void)?

    enum TabTitle: String {
        case taxiParty = "택시팟"
        case myParty = "마이팟"
        case myPage = "설정"
    }

    enum TabToolbarItem {
        case add
        case none

        var systemName: String {
            switch self {
            case .add:
                return "plus"
            case .none:
                return ""
            }
        }
    }

    init(_ tab: TabTitle) {
        self.tab = tab
        self.toolbarItem = .none
        self.action = nil
    }

    init(_ tab: TabTitle, toolbarItem: TabToolbarItem, action: @escaping () -> Void) {
        self.tab = tab
        self.toolbarItem = toolbarItem
        self.action = action
    }

    var body: some View {
        HStack(alignment: .center) {
            Text(tab.rawValue)
                .font(.custom("AppleSDGothicNeo-Bold", size: 25))
            Spacer()
            if let action = action {
                Button {
                    action()
                } label: {
                    Image(systemName: toolbarItem.systemName)
                        .imageScale(.large)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 19)
    }
}
