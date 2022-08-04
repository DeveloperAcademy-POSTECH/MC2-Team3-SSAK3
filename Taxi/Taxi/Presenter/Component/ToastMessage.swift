//
//  ToastMessage.swift
//  Taxi
//
//  Created by JongHo Park on 2022/08/04.
//

import SwiftUI

struct ToastMessage: ViewModifier {

    private let message: String
    @Binding private var isShowing: Bool

    init(isShowing: Binding<Bool>, message: String) {
        self.message = message
        self._isShowing = isShowing
    }

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if isShowing {
                Text(message)
                    .fontWeight(.semibold)
                    .padding(EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32))
                    .background(Color.customGray, in: RoundedRectangle(cornerRadius: 15))
                    .transition(.opacity.animation(.easeInOut))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isShowing = false
                        }
                    }
                    .padding(.bottom, 48)
                    .zIndex(1)
            }
        }
    }
}

extension View {
    func toast(isShowing: Binding<Bool>, message: String) -> some View {
        self.modifier(ToastMessage(isShowing: isShowing, message: message))
    }
}

struct ToastMessage_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World")
            .toast(isShowing: .constant(true), message: "Hello World")
    }
}
