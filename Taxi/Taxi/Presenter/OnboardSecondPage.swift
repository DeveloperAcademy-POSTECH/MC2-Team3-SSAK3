//
//  OnboardSecondPage.swift
//  Taxi
//
//  Created by joy on 2022/06/16.
//

import SwiftUI

struct OnboardSecondPage: View {
    var body: some View {
        VStack {
            SkippButtonView()
            Spacer()
            SecondPageWordingView()
            Spacer()
            SecondImageView()
            NextButtonView()
        }
    }
}
// MARK: 텍스트 위치 고정시키는 법이 모든 컴포넌트의 높이를 고정시키는 방법 밖에 없을까? - 우디
struct SecondPageWordingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("택시팟이 없다면")
                .signUpTitle()
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
            HStack(spacing: 0) {
                Text("직접 ")
                    .signUpAgreement()
                Text("택시팟")
                    .font(Font.system(size: 16, weight: .medium))
                    .foregroundColor(.customYellow)
                Image(systemName: "sparkle")
                    .font(Font.system(size: 16, weight: .medium))
                    .foregroundColor(.customYellow)
                Text("을 생성해 파티원을 구해보세요.")
                    .signUpAgreement()
            }
            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        }
        .padding(.leading, 18)
    }
}

struct SecondImageView: View {
    private func calculateOffset() -> CGFloat {
        let deviceWidth: CGFloat = UIScreen.main.bounds.width
        return deviceWidth * ( 20 / 375)
    }
    var body: some View {
        HStack {
        Image("PeopleImage")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .offset(x: calculateOffset())
        }
    }
}

struct OnboardSecondPage_Previews: PreviewProvider {
    static var previews: some View {
        OnboardSecondPage()
    }
}
