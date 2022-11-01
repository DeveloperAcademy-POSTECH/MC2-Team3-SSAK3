//
//  LicenseView.swift
//  Taxi
//
//  Created by Yosep on 2022/10/30.
//

import SwiftUI

struct LicenseView: View {
    let email: String = "popopothelp@gmail.com"

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
                    .foregroundColor(.darkGray)
                    .font(Font.custom("AppleSDGothicNeo-Medium", size: 15))
                Text("The following sets forth attribution notices for third party software that may be contained in this application.")
                    .foregroundColor(.darkGray)
                    .font(Font.custom("AppleSDGothicNeo-Medium", size: 15))

                Group {
                    Text("If you have any questions about these notices, please email us at ")
                        .foregroundColor(.darkGray)
                        .font(Font.custom("AppleSDGothicNeo-Medium", size: 15))
                    + Text("\(email)").underline().foregroundColor(.blue).font(Font.custom("AppleSDGothicNeo-Medium", size: 15))
                }.onTapGesture { EmailHelper.shared.send(subject: "[popopot]", body: "[제안 내용]", recipient: ["popopothelp@gmail.com"]) }
            }.padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))

            Rectangle()
                .fill(Color(red: 240 / 255, green: 240 / 255, blue: 240 / 255))
                .frame(height: 2)
                .padding(5)

            licenseContents(title: "firebase-ios-sdk", url: "[https://github.com/firebase/firebase-ios-sdk/blob/master/LICENSE](https://github.com/firebase/firebase-ios-sdk/blob/master/LICENSE)", copyright: "Copyright 2018 Google LLC", licenseName: "Apache License 2.0")
            licenseContents(title: "Amplitude-iOS", url: "[https://github.com/amplitude/Amplitude-iOS/blob/main/LICENSE](https://github.com/amplitude/Amplitude-iOS/blob/main/LICENSE)", copyright: "Copyright (c) 2014 Amplitude Analytics", licenseName: "MIT License")
            licenseContents(title: "SDWebImageSwiftUI", url: "[https://github.com/SDWebImage/SDWebImageSwiftUI/blob/master/LICENSE](https://github.com/SDWebImage/SDWebImageSwiftUI/blob/master/LICENSE)", copyright: "Copyright (c) 2019 lizhuoli1126@126.com", licenseName: "MIT License")
            licenseContents(title: "nanopb", url: "[https://github.com/nanopb/nanopb/blob/master/LICENSE.txt](https://github.com/nanopb/nanopb/blob/master/LICENSE.txt)", copyright: "Copyright (c) 2011 Petteri Aimonen", licenseName: "zlib License")
            licenseContents(title: "SwiftKeychainWrapper", url: "[https://github.com/jrendel/SwiftKeychainWrapper/blob/develop/LICENSE](https://github.com/jrendel/SwiftKeychainWrapper/blob/develop/LICENSE)", copyright: "Copyright (c) 2014 Jason Rendel", licenseName: "MIT License")
            licenseContents(title: "SwiftUI-Introspect", url: "[https://github.com/siteline/SwiftUI-Introspect/blob/master/LICENSE](https://github.com/siteline/SwiftUI-Introspect/blob/master/LICENSE)", copyright: "Copyright (c) 2019 Timber Software", licenseName: "MIT License")
        }
    }

    private func licenseContents(title: String, url: String, copyright: String, licenseName: String) -> some View {
        var licenseContentsView: some View {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255))
                    .frame(height: 50)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(Font.custom("AppleSDGothicNeo-Bold", size: 18))
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    VStack(alignment: .leading) {
                        Text(.init(url))
                            .underline()
                            .accentColor(.blue)
                            .font(Font.custom("AppleSDGothicNeo-Medium", size: 15))
                        Text(copyright)
                            .font(Font.custom("AppleSDGothicNeo-Medium", size: 15))
                            .foregroundColor(.darkGray)
                        Text(licenseName)
                            .font(Font.custom("AppleSDGothicNeo-Medium", size: 15))
                    }.padding(EdgeInsets(top: 0, leading: 35, bottom: 0, trailing: 15))
                }
            }
        }
        return licenseContentsView
    }
}
