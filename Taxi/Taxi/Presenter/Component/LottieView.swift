//
//  LottieView.swift
//  Taxi
//
//  Created by JongHo Park on 2022/07/08.
//

import UIKit
import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let filename: String

    func makeUIView(context: Context) -> UIView {
        // 3.
        let view = UIView(frame: .zero)
        // 4. Add animation
        let animationView = AnimationView()
        // 사용자 애니메이션 파일명
        animationView.animation = Animation.named(filename)
        // 애니메이션 크기가 적절하게 조정될 수 있도록
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        // 애니메이션 재생
        animationView.play()

        // 컨테이너의 너비와 높이를 자동으로 지정할 수 있도록
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        // 5. 자동완성 기능
        NSLayoutConstraint.activate([
            // 레이아웃의 높이와 넓이의 제약
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {

    }
}
