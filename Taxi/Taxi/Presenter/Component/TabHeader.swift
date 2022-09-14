//
//  TabTitle.swift
//  Taxi
//
//  Created by 민채호 on 2022/09/14.
//

import SwiftUI

struct TabHeader: View {
    private let tab: Tab
    private let toolbarItem: TabToolbarItem
    private let action: (() -> Void)?

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

    init(_ tab: Tab) {
        self.tab = tab
        self.toolbarItem = .none
        self.action = nil
    }

    init(_ tab: Tab, toolbarItem: TabToolbarItem, action: @escaping () -> Void) {
        self.tab = tab
        self.toolbarItem = toolbarItem
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
                    Image(systemName: toolbarItem.systemName)
                        .imageScale(.large)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 19)
    }
}
