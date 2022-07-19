//
//  OnboardSecondPage.swift
//  Taxi
//
//  Created by joy on 2022/06/16.
//

import SwiftUI

struct OnboardSecondPageView: View {
    var body: some View {
        VStack {
            Spacer()
            SecondPageWordingView()
            Spacer()
            SecondImageView()
            Spacer()
            Spacer()
            Spacer()
        }
    }
}
// MARK: 텍스트 위치 고정시키는 법이 모든 컴포넌트의 높이를 고정시키는 방법 밖에 없을까? - 우디
struct SecondPageWordingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("택시팟이 없나요?")
                .kerning(-0.1)
                .signUpTitle()
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
            HStack(spacing: 0) {
                Text("직접 ")
                    .kerning(-0.3)
                    .signUpAgreement()
                Text("택시팟")
                    .kerning(-0.3)
                    .signUpAgreement()
                Text("을 생성해 파티원을 구해보세요.")
                    .kerning(-0.3)
                    .signUpAgreement()
            }
            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        }
        .padding(.top, 10)
        .padding(.leading, 20)
    }
}

struct SecondImageView: View {
    var body: some View {
        HStack {
        Image("PeopleImage")
            .resizable()
            .frame(width: 227.08, height: 186)
            .aspectRatio(contentMode: .fit)
        }
        .padding(.top, 50)
        .padding(.trailing, 20)
    }
}

struct OnboardSecondPageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardSecondPageView()
    }
}
