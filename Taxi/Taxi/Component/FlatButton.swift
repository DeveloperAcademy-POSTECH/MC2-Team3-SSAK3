//
//  FlatButton.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/15.
//

import SwiftUI

struct FlatButton: View {
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
                .background(Color.customYellow)
        }
        .disabled(disabled)
        .opacity(disabled ? 0.3 : 1)
        .buttonStyle(.plain)
    }
}

struct FlatButton_Previews: PreviewProvider {
    static var previews: some View {
        FlatButton("다음") {}
            .previewLayout(.sizeThatFits)
        FlatButton("다음", true) {}
            .previewLayout(.sizeThatFits)
    }
}
