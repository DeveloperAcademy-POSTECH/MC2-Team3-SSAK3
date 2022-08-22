//
//  Splash.swift
//  Taxi
//
//  Created by 민채호 on 2022/08/22.
//

import SwiftUI

struct Splash: View {
    var body: some View {
        ZStack {
            Color.customBlack
            Image(ImageName.splashIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 48)
        }
        .ignoresSafeArea()
    }
}

#if DEBUG
struct Splash_Previews: PreviewProvider {
    static var previews: some View {
        Splash()
    }
}
#endif
