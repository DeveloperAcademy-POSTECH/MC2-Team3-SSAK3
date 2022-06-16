//
//  OnboardFirstPage.swift
//  Taxi
//
//  Created by joy on 2022/06/15.
//

import SwiftUI

struct OnboardFirstPage: View {
    var body: some View {
        VStack {
            SkippButtonView()
            Spacer()
            WordingView()
            Spacer()
            ImageView()
            NextButtonView()
        }
    }
}

struct SkippButtonView: View {
    var body: some View {
        HStack {
            Spacer()
        Text("건너뛰기")
        }.padding()
    }
}

struct WordingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("원하는 시간에 함께 택시 타기")
                .signUpTitle()
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
            HStack(spacing: 0) {
                Text("원하는 시간의 ")
                    .signUpAgreement()
                Text("택시팟")
                    .font(Font.system(size: 16, weight: .medium))
                    .foregroundColor(.customYellow)
                Image(systemName: "sparkle")
                    .font(Font.system(size: 16, weight: .medium))
                    .foregroundColor(.customYellow)
                Text("에 참여해 택시비를 아껴보세요.")
                    .signUpAgreement()
            }
            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        }
        .padding(.leading, 18)
    }
}

struct ImageView: View {
    private func calculateOffset() -> CGFloat {
        let deviceWidth: CGFloat = UIScreen.main.bounds.width
        return deviceWidth * (1 / 375)
    }
    var body: some View {
        Spacer()
        HStack {
        Image("ClockImage")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .offset(x: calculateOffset())
        }
    }
}

struct NextButtonView: View {
    var body: some View {
        RoundedButton("다음") {
            print("hello")
        }
    }
}

struct OnboardFirstPage_Previews: PreviewProvider {
    static var previews: some View {
        OnboardFirstPage()
    }
}
