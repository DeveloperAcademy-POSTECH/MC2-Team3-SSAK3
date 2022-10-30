//
//  LicenseView.swift
//  Taxi
//
//  Created by Yosep on 2022/10/30.
//

import SwiftUI

struct LicenseView: View {
    var body: some View {
        opensourceLicense2
    }
}

private extension LicenseView {
    var opensourceLicense2: some View {
        NavigationView {
            Button {
                print("opensourceLicense")
            } label: {
                Text("오픈소스 라이선스")
                    .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
                    .padding()
            }
        }.navigationBarTitle("Bar Title", displayMode: .inline)
    }
}

struct LicenseView_Previews: PreviewProvider {
    static var previews: some View {
        LicenseView()
    }
}
