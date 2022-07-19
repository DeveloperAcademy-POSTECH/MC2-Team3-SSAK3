//
//  OnboardThirdPage.swift
//  Taxi
//
//  Created by joy on 2022/06/16.
//

import SwiftUI

struct OnboardThirdPageView: View {
    var body: some View {
    VStack {
        Spacer()
        ThirdPageWordingView()
        Spacer()
        ThirdImageView()
        Spacer()
        Spacer()
        Spacer()
        }
    }
}

struct ThirdPageWordingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("준비되셨나요?")
                .kerning(-0.1)
                .signUpTitle()
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
            HStack(spacing: 0) {
                Text("포포팟")
                    .kerning(-0.3)
                    .font(Font.system(size: 16, weight: .bold))
                    .foregroundColor(.customYellow)
                Image(systemName: "sparkle")
                    .font(Font.system(size: 16, weight: .semibold))
                    .foregroundColor(.customYellow)
                Text("으로 편하게 택시팟을 이용해보세요.")
                    .kerning(-0.3)
                    .signUpAgreement()
            }
            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        }
        .padding(.top, 10)
        .padding(.leading, 20)
    }
}

struct ThirdImageView: View {
    var body: some View {
        HStack {
        Image("TaxiImage")
            .resizable()
            .frame(width: 193.43, height: 197.36)
            .aspectRatio(contentMode: .fit)
        }
        .padding(.top, 50)
        .padding(.trailing, 20)
    }
}

struct OnboardThirdPageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardThirdPageView()
    }
}
