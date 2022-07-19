//
//  OnboardFirstPage.swift
//  Taxi
//
//  Created by joy on 2022/06/15.
//

import SwiftUI

struct OnboardFirstPageView: View {
    var body: some View {
        VStack {
            Spacer()
            WordingView()
            Spacer()
            ImageView()
            Spacer()
            Spacer()
            Spacer()
        }
    }
}

struct WordingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("부담 없이 참여해보세요")
                .kerning(-0.1)
                .signUpTitle()
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
            HStack(spacing: 0) {
                Text("원하는 시간의 ")
                    .kerning(-0.3)
                    .signUpAgreement()
                Text("택시팟")
                    .kerning(-0.3)
                    .signUpAgreement()
                Text("에 참여해 택시비를 아껴보세요.")
                    .kerning(-0.3)
                    .signUpAgreement()
            }
            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        }
        .padding(.top, 10)
        .padding(.leading, 20)
    }
}

struct ImageView: View {
    var body: some View {
        HStack {
        Image("ClockImage")
            .resizable()
            .frame(width: 200.11, height: 197.36)
            .aspectRatio(contentMode: .fit)
        }
        .padding(.top, 50)
        .padding(.trailing, 20)
    }
}

struct OnboardFirstPageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardFirstPageView()
    }
}
