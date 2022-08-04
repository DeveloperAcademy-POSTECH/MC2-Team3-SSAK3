//
//  Onboarding.swift
//  Taxi
//
//  Created by joy on 2022/06/16.
//

import SwiftUI

struct OnboardingView: View {
    @State private var index = 0
    @AppStorage("skipOnboarding") private var skipOnboarding: Bool = false

    init() {
        setupAppearance()
    }
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    TabView(selection: $index) {
                        Page1()
                            .tag(0)
                        Page2()
                            .tag(1)
                        Page3()
                            .tag(2)
                    }
                    .padding(10)
                    .tabViewStyle(.page)
                    RoundedButton(index == 2 ? "시작하기" : "다음") {
                        if index == 2 {
                            skipOnboarding = true
                        } else {
                            index += 1
                        }
                    }
                    .padding()
                }
                NavigationLink(isActive: $skipOnboarding) {
                    SignHome()
                } label: {
                    EmptyView()
                }
                .isDetailLink(false)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: toolbar)

        }
    }

    private func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }

}
private extension OnboardingView {
    @ToolbarContentBuilder
    func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            skipButton
        }
    }
    var skipButton: some View {
        Button {
            skipOnboarding = true
        } label: {
            Text("건너뛰기")
                .signUpAgreement()
        }
    }
}

struct Page1: View {
    var body: some View {
        VStack {
            WordingView()
            Spacer()
            ImageView()
            Spacer()
            Spacer()
        }
    }
}

struct Page2: View {
    var body: some View {
        VStack {
            SecondPageWordingView()
            Spacer()
            SecondImageView()
            Spacer()
            Spacer()
        }
    }
}

struct Page3: View {
    var body: some View {
        VStack {
            ThirdPageWordingView()
            Spacer()
            ThirdImageView()
            Spacer()
            Spacer()
        }
    }
}

struct Finish: View {
    var body: some View {
        TabView {
            Text("finish")
                .frame(width: 100, height: 100)
                .background {
                    Color.blue
                }
        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
