//
//  RoundedButton.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/09.
//

import SwiftUI

struct RoundedButton: View {
    private let text: String
    private let disabled: Bool
    private let action: () -> Void

    init(_ title: String, _ disabled: Bool = false, action: @escaping () -> Void) {
        self.text = title
        self.disabled = disabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity)
                .background(Color.customYellow, in: RoundedRectangle(cornerRadius: 15))
                .padding(.horizontal)
        }
        .disabled(disabled)
        .opacity(disabled ? 0.3 : 1)
        .buttonStyle(.plain)
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButton("택시팟 생성") {}
            .previewLayout(.sizeThatFits)
        RoundedButton("택시팟 생성", true) {}
            .previewLayout(.sizeThatFits)
    }
}
