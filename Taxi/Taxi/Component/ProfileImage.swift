//
//  ProfileImage.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/12.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileImage: View {
    let user: User
    private let diameter: CGFloat

    init(_ user: User, diameter: CGFloat) {
        self.user = user
        self.diameter = diameter
    }

    var body: some View {
        if let imageURL = user.profileImage {
            WebImage(url: URL(string: imageURL))
                .profileCircle(diameter)
        } else {
            ZStack {
                Circle()
                    .foregroundColor(.gray)
                    .frame(width: diameter, height: diameter)
                Text(user.nickname.prefix(1))
                    .foregroundColor(.white)
                    .font(.system(size: diameter/1.5))
            }
        }
    }
}

struct ProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImage(User(id: "1", nickname: "아보", profileImage: "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/f202fce4-a5b6-4e40-9f5e-f22eaf4edd87/ProfileDummy.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220611%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220611T030635Z&X-Amz-Expires=86400&X-Amz-Signature=8756de2e65dc2b6f616fb7a697bbebbaf8f779b53e3481e52fb183b4b5709821&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22ProfileDummy.png%22&x-id=GetObject"), diameter: 100)
            .previewLayout(.sizeThatFits)
        ProfileImage(User(id: "1", nickname: "아보", profileImage: nil), diameter: 100)
            .previewLayout(.sizeThatFits)
        ProfileImage(User(id: "1", nickname: "아보", profileImage: nil), diameter: 80)
            .previewLayout(.sizeThatFits)
        ProfileImage(User(id: "1", nickname: "아보", profileImage: nil), diameter: 40)
            .previewLayout(.sizeThatFits)
    }
}
