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
    private let loading: Bool

    init(_ title: String, _ disabled: Bool = false, loading: Bool = false, action: @escaping () -> Void) {
        self.text = title
        self.disabled = disabled
        self.action = action
        self.loading = loading
    }

    var body: some View {
        Button(action: action) {
            if loading {
                ProgressView()
            } else {
                Text(text)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
            }
        }
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity)
        .background(background)
        .padding(.horizontal)
        .disabled(disabled || loading)
        .opacity(disabled || loading ? 0.6 : 1)
        .buttonStyle(.plain)
    }

    private var background: some View {
        RoundedRectangle(cornerRadius: 15).fill(Color.customYellow)
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButton("택시팟 생성") {}
            .previewLayout(.sizeThatFits)
        RoundedButton("택시팟 생성", true) {}
            .previewLayout(.sizeThatFits)
        RoundedButton("택시팟 생성", loading: true) {

        }
        .previewLayout(.sizeThatFits)
    }
}
