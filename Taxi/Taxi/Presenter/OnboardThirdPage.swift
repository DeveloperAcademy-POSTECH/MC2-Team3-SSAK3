//
//  OnboardThirdPage.swift
//  Taxi
//
//  Created by joy on 2022/06/16.
//

import SwiftUI

struct OnboardThirdPage: View {
    var body: some View {
    VStack {
        SkippButtonView()
        Spacer()
        ThirdPageWordingView()
        Spacer()
        ThirdImageView()
        NextButtonView()
        }
    }
}

struct ThirdPageWordingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("준비되셨나요?")
                .signUpTitle()
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
            HStack(spacing: 0) {
                Text("포포팟")
                    .font(Font.system(size: 16, weight: .medium))
                    .foregroundColor(.customYellow)
                Image(systemName: "sparkle")
                    .font(Font.system(size: 16, weight: .medium))
                    .foregroundColor(.customYellow)
                Text("과 함께 쉽고 빠르게 택시비를 아껴봅시다.")
                    .signUpAgreement()
            }
            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        }
        .padding(.leading, 18)
    }
}

struct ThirdImageView: View {
    private func calculateOffset() -> CGFloat {
        let deviceWidth: CGFloat = UIScreen.main.bounds.width
        return deviceWidth * (53 / 375)
    }
    var body: some View {
        HStack {
        Image("TaxiImage")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .offset(x: calculateOffset())
        }
    }
}

struct OnboardThirdPage_Previews: PreviewProvider {
    static var previews: some View {
        OnboardThirdPage()
    }
}
