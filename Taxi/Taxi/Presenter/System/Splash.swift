//
//  Splash.swift
//  Taxi
//
//  Created by 민채호 on 2022/08/22.
//

import SwiftUI

struct Splash: View {
    @State private var isProgressViewShowing = false

    var body: some View {
        ZStack {
            Color.customBlack
            VStack(spacing: 16) {
                Image(ImageName.splashIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 48)
                if isProgressViewShowing {
                    ProgressView()
                        .tint(.white)
                }
            }
            .animation(.easeInOut, value: isProgressViewShowing)
        }
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isProgressViewShowing = true
            }
        }
    }
}

#if DEBUG
struct Splash_Previews: PreviewProvider {
    static var previews: some View {
        Splash()
    }
}
#endif
