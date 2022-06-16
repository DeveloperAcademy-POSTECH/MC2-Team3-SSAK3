//
//  Onboarding.swift
//  Taxi
//
//  Created by joy on 2022/06/16.
//

import SwiftUI

struct OnboardingView: View {
    @State private var index = 0
    @Binding var isContentView: Bool
    var body: some View {
        VStack {
            SkippButtonView()
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
            .onAppear {
                setupAppearance()
            }
            RoundedButton(index == 2 ? "시작하기" : "다음") {
                if index == 2 {
                    isContentView = true
                }
                index = (index + 1) % 3
            }
        }
    }
}
func setupAppearance() {
    UIPageControl.appearance().currentPageIndicatorTintColor = .black
    UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
}

struct SkippButtonView: View {
    var body: some View {
        HStack {
            Spacer()
        Text("건너뛰기")
                .signUpAgreement()
        }.padding()
    }
}

struct ContentView: View {
    var body: some View {
        Text("ContentView")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isContentView: .constant(false))
    }
}
