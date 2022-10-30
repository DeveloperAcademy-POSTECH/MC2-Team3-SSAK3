//
//  FullScreenDismissGesture.swift
//  Taxi
//
//  Created by JongHo Park on 2022/10/30.
//

import SwiftUI

struct FullScreenDismissGesture: ViewModifier {

    @Binding private var isShowing: Bool
    @State private var yOffset: CGFloat = .zero
    init(isShowing: Binding<Bool>) {
        self._isShowing = isShowing
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation(.interactiveSpring()) {
                    if value.translation.height > 0 {
                        yOffset = value.translation.height
                    }
                }
            }
            .onEnded { value in
                if value.translation.height > 60 {
                    isShowing = false
                } else {
                    yOffset = .zero
                }
            }
    }

    func body(content: Content) -> some View {
        content
            .offset(y: yOffset)
            .gesture(dragGesture)
    }
}

extension View {
    func enableDismissGesture(_ isShowing: Binding<Bool>) -> some View {
        modifier(FullScreenDismissGesture(isShowing: isShowing))
    }
}
