//
//  ImageExtension.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/11.
//

import SwiftUI
import SDWebImageSwiftUI

extension Image {
    func profileCircle(_ diameter: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .frame(width: diameter, height: diameter)
    }
}

extension WebImage {
    func profileCircle(_ diameter: CGFloat) -> some View {
        self
            .placeholder {
                Circle().stroke().foregroundColor(.darkGray)
                    .overlay {
                        Image(systemName: "sparkle")
                            .font(.system(size: diameter / 1.5))
                    }
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .frame(width: diameter, height: diameter)
    }
}
