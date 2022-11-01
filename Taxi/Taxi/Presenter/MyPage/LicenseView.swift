//
//  LicenseView.swift
//  Taxi
//
//  Created by Yosep on 2022/10/30.
//

import SwiftUI

struct LicenseView: View {
    var body: some View {
        NavigationView {
            opensourceLicense
        }.navigationBarTitle("오픈소스 라이선스")
    }
}

private extension LicenseView {
    var opensourceLicense: some View {
        ScrollView {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(red: 0 / 255, green: 0 / 255, blue: 0 / 255))
                    .frame(height: 50)
                    .padding(5)
                Text("OSS Notice | popopot-iOS")
                    .font(Font.custom("AppleSDGothicNeo-Bold", size: 18))
                    .foregroundColor(.white)
                    .padding(20)
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("This application is Copyright © SSAK3 Team. All rights reserved.")
                    .font(Font.custom("AppleSDGothicNeo-Medium", size: 15))
                    .foregroundColor(.darkGray)
                Text("The following sets forth attribution notices for third party software that may be contained in this application.")
                    .font(Font.custom("AppleSDGothicNeo-Medium", size: 15))
                    .foregroundColor(.darkGray)
                Text("If you have any questions about these notices, please email us at popopothelp@gmail.com")
                    .font(Font.custom("AppleSDGothicNeo-Medium", size: 15))
                    .foregroundColor(.darkGray)
            }.padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))

            Rectangle()
                .fill(Color(red: 240 / 255, green: 240 / 255, blue: 240 / 255))
                .frame(height: 2)
                .padding(5)

            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255))
                    .frame(height: 50)
                VStack(alignment: .leading) {
                    Text("This application")
                        .font(Font.custom("AppleSDGothicNeo-Bold", size: 18))
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    VStack(alignment: .leading) {
                        Text(.init("[Link Example](https://www.google.es/)"))
                            .underline()
                            .accentColor(.blue)
                            .font(Font.custom("AppleSDGothicNeo-Medium", size: 15))
                        Text("Copyright 2022 popopot")
                            .font(Font.custom("AppleSDGothicNeo-Medium", size: 15))
                            .foregroundColor(.darkGray)
                        Text("MIT License")
                            .font(Font.custom("AppleSDGothicNeo-Medium", size: 15))
                    }.padding(EdgeInsets(top: 0, leading: 35, bottom: 0, trailing: 15))
                }
            }

        }
    }
}

struct LicenseView_Previews: PreviewProvider {
    static var previews: some View {
        LicenseView()
    }
}
