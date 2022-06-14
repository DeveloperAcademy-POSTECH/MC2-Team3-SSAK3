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
            .font(Font.custom("AppleSDGothicNeo-Bold", size: 20))
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
            .font(Font.custom("AppleSDGothicNeo-Regular", size: 12))
    }
}

struct ListMainTitle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(.customBlack)
            .font(Font.custom("AppleSDGothicNeo-Regular", size: 36))
    }
}

struct SignUpTitle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(.customBlack)
            .font(Font.custom("AppleSDGothicNeo-Bold", size: 25))
    }
}

struct SignUpPlaceholder: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(.signUpYellowGray)
            .font(Font.custom("AppleSDGothicNeo-Regular", size: 20))
    }
}

struct SignUpExplain: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(.signUpYellowGray)
            .font(Font.custom("AppleSDGothicNeo-Regular", size: 14))
    }
}

struct SignUpAgreement: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(.signUpYellowGray)
            .font(Font.custom("AppleSDGothicNeo-Regular", size: 16))
    }
}



struct CalendarDay: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(.customGray)
            .font(.system(size: 12, weight: .medium))
    }
}


struct CalendarTitle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(.charcoal)
            .font(.system(size: 18, weight: .medium))
    }
}

struct CalendarArrow: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.system(size: 18, weight: .medium))
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
    func signUpTitle() -> some View {
        self.modifier(SignUpTitle())
    }
    func signUpPlaceholder() -> some View {
        self.modifier(SignUpPlaceholder())
    }
    func signUpExplain() -> some View {
        self.modifier(SignUpExplain())
    }
    func signUpAgreement() -> some View {
        self.modifier(SignUpAgreement())
    }
    func calendarDay() -> some View {
            self.modifier(CalendarDay())
        }
    func calendarDate() -> some View {
        self.modifier(CalendarDate())
    }
    func calendarTitle() -> some View {
        self.modifier(CalendarTitle())
    }
    func calendarArrow() -> some View {
        self.modifier(CalendarArrow())
    }
}

extension Text {
    func info() -> Text {
        return self
            .foregroundColor(.charcoal)
            .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
    }
    func caption() -> Text {
        return self
            .foregroundColor(.darkGray)
            .font(Font.custom("AppleSDGothicNeo-Medium", size: 14))
    }
}
