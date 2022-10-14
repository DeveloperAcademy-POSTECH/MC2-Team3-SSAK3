//
//  SignUpComplete.swift
//  Taxi
//
//  Created by JongHo Park on 2022/08/11.
//

import SwiftUI

struct SignUpComplete: View {

    // MARK: - States
    @ObservedObject private var viewModel: SignUpViewModel
    @StateObject var signInViewModel: SignInViewModel = SignInViewModel()
    @Binding private var isSignUpActive: Bool
    @State private var goToSignIn: Bool = false

    init(_ viewModel: SignUpViewModel, _ isSignUpActive: Binding<Bool>) {
        self.viewModel = viewModel
        self._isSignUpActive = isSignUpActive
    }

    var body: some View {
        ZStack {
            SparkleAnimation(startX: 300, startY: 50, 0.8)
            SparkleAnimation(startX: 50, startY: 650, 0.3)
            VStack(spacing: 0) {
                Spacer()
                Text("포포팟\(Image(systemName: "sparkle")) 가입 완료!")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.charcoal)

                Text("\(viewModel.nickname.value)님 환영해요")
                    .signUpTitle()
                    .padding(.top, 12)

                Text("입력하신 이메일 주소로 보낸\n본인 인증 메일을 확인 후 로그인해주세요")
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.charcoal)
                    .padding(.top, 48)
                Spacer()
                RoundedButton("시작하기") {
                    goToSignIn = true
                }
                NavigationLink(isActive: $goToSignIn) {
                    SignIn(
                        signInViewModel: signInViewModel,
                        signUpEmail: viewModel.email.value,
                        signUpPassword: viewModel.password.value
                    )
                } label: {
                    EmptyView()
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarHidden(true)
    }
}

// MARK: - Animations
private extension SignUpComplete {

    struct SparkleAnimation: View {
        @State private var xPosition: CGFloat
        @State private var yPosition: CGFloat
        @State private var rotation: Double = 45
        @State private var isAnimating: Bool = false
        let startXPosition: CGFloat
        let startYPosition: CGFloat
        let opacity: Double

        init(startX: CGFloat, startY: CGFloat, _ opacity: Double) {
            self.startXPosition = startX
            self.startYPosition = startY
            _xPosition = .init(initialValue: startX)
            _yPosition = .init(initialValue: startY)
            self.opacity = opacity
        }

        var body: some View {
            Image(systemName: "sparkle")
                .resizable()
                .frame(width: 300, height: 300, alignment: .center)
                .foregroundColor(.customYellow)
                .rotationEffect(.degrees(rotation))
                .onAppear {
                    isAnimating = true
                    animateSparkle()
                }
                .opacity(opacity)
                .position(x: xPosition, y: yPosition)
                .onDisappear {
                    isAnimating = false
                }
        }

        private func animateSparkle() {
            withAnimation(.easeInOut(duration: 5)) {
                xPosition = startXPosition + (40 * Double.random(in: -1...1))
                yPosition = startYPosition + (40 * Double.random(in: -1...1))
                rotation += Double.random(in: -45...45)
            }
            if isAnimating {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                    animateSparkle()
                }
            }
        }
    }
}

#if DEBUG
// MARK: - Preview
struct SignUpComplete_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignUpComplete(SignUpViewModel(), .constant(true))
        }
    }
}
#endif
