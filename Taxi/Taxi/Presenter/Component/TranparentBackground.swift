//
//  TransparentBackground.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/17.
//

import SwiftUI

struct TranparentBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct ClearBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(TranparentBackground())
    }
}
