//
//  TextStyleExtension.swift
//  Taxi
//
//  Created by joy on 2022/06/10.
//

import Foundation
import SwiftUI

struct MainTitle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(.customBlack)
            .font(Font.custom("AppleSDGothicNeo-Bold", size: 26))
    }
}

struct SubTitle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(.customGray)
            .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
    }
}

struct SubTitleSelect: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(.darkGray)
            .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
    }
}

struct ChatStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(.customBlack)
            .font(Font.custom("AppleSDGothicNeo-Medium", size: 16))
    }
}

struct InchatNotification: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(.customBlack)
            .font(Font.custom("AppleSDGothicNeo-Regular", size: 10))
    }
}

struct ListMainTitle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(.customBlack)
            .font(Font.custom("AppleSDGothicNeo-Regular", size: 10))
    }
}

extension View {
    func mainTitle() -> some View {
        self.modifier(MainTitle())
    }
    func subTitle() -> some View {
        self.modifier(SubTitle())
    }
    func subTitleSelect() -> some View {
        self.modifier(SubTitleSelect())
    }
    func chatStyle() -> some View {
        self.modifier(ChatStyle())
    }
    func inchatNotification() -> some View {
        self.modifier(InchatNotification())
    }
    func listMaintitle() -> some View {
        self.modifier(ListMainTitle())
    }
}
