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
            opensourceLicense2
        }.navigationBarTitle("오픈소스 라이선스")
    }
}

private extension LicenseView {
    var opensourceLicense2: some View {
        ScrollView {
            Text("오픈소스 라이선스")
                .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
                .padding()
            Text("오픈소스 라이선스")
                .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
                .padding()
            Text("오픈소스 라이선스")
                .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
                .padding()
            Text("오픈소스 라이선스")
                .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
                .padding()
        }
    }
}

struct LicenseView_Previews: PreviewProvider {
    static var previews: some View {
        LicenseView()
    }
}
