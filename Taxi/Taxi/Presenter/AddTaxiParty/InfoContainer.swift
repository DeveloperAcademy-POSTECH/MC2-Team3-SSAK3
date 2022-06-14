//
//  InfoContainer.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/14.
//

import SwiftUI

// MARK: - 정보 선택 영역 가이드 뷰
extension AddTaxiParty {
    struct InfoContainer: ViewModifier {
        let title: String
        let selectedInfo: String
        let toggle: Bool
        let onClick: () -> Void

        func body(content: Content) -> some View {
            VStack(alignment: .leading, spacing: 0) {
                section
                    .zIndex(2)
                content
                    .zIndex(1)
                    .frame(height: toggle ? nil : 0)
                    .contentShape(Rectangle())
                    .clipped()
            }
        }

        private var section: some View {
            Button {
                onClick()
            } label: {
                HStack {
                    Text(title)
                        .font(.system(size: 18, weight: toggle ? .bold: .medium))
                        .foregroundColor(toggle ? Color.customBlack : .darkGray)
                        .lineLimit(1)
                    Spacer()

                    Text(selectedInfo)
                        .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
                        .foregroundColor(toggle ? .clear : .customBlack)

                    Image(systemName: toggle ? "chevron.down": "chevron.up")
                        .imageScale(.large)
                        .foregroundColor(!selectedInfo.isEmpty ? Color.charcoal : Color.darkGray)
                }
                .contentShape(Rectangle())
            }
            .padding()
            .border(toggle ? .clear : .gray.opacity(0.2), width: 1)
            .background(toggle ? Color.selectYellow.shadow(color: .black.opacity(0.12), radius: 1, x: 0, y: 1) : Color.white.shadow(radius: 0))
        }
    }
}
// MARK: - Info Container Modifier Extension
extension View {
    func toInfoContainer(title: String, selectedInfo: String, toggle: Bool, onClick: @escaping () -> Void) -> some View {
        self.modifier(AddTaxiParty.InfoContainer(title: title, selectedInfo: selectedInfo, toggle: toggle, onClick: onClick))
    }
}
// MARK: - InfoContainer 프리뷰
struct InfoContainerPreview: PreviewProvider {
    static var previews: some View {
        Text("프리뷰")
            .toInfoContainer(title: "프리뷰", selectedInfo: "프리뷰", toggle: true) {}
    }
}
