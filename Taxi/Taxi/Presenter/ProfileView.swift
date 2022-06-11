//
//  ProfileView.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/08.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @State private var showPicker: Bool = false
    @State private var newImage: UIImage?

    // DummyData
    let id: String = "0"
    @State private var nickname: String = "Avo"
    @State private var profileImage: String? = "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/f202fce4-a5b6-4e40-9f5e-f22eaf4edd87/ProfileDummy.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220611%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220611T030635Z&X-Amz-Expires=86400&X-Amz-Signature=8756de2e65dc2b6f616fb7a697bbebbaf8f779b53e3481e52fb183b4b5709821&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22ProfileDummy.png%22&x-id=GetObject"

    var body: some View {
        VStack {
            Button {
                showPicker.toggle()
            } label: {
                if let imageURL = profileImage {
                    WebImage(url: URL(string: imageURL))
                        .resizable()
                        .placeholder {
                            Circle().stroke().foregroundColor(.black)
                                .overlay {
                                    ProgressView()
                                }
                        }
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 160)
                        .overlay(alignment: .bottom) {
                            Text("편집")
                        }
                } else {
                    ZStack {
                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 160, height: 160)
                        Text(nickname.prefix(1))
                            .foregroundColor(.black)
                    }
                    .overlay(alignment: .bottom) {
                        Text("편집")
                    }
                }
            }
            .sheet(isPresented: $showPicker) {
                PhotoPicker(filter: .images, limit: 1) { results in
                    PhotoPicker.convertToUIImageArray(fromResults: results) { (imagesOrNil, errorOrNil) in
                        if let error = errorOrNil {
                            print(error)
                        }
                        if let images = imagesOrNil {
                            if let first = images.first {
                                newImage = first
                            }
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
            HStack {
                Text("닉네임")
                Spacer()
                TextField("닉네임", text: $nickname)
                    .disableAutocorrection(true)
            }
            Button {
                // TODO: Update User Nickname, Profile Image
            } label: {
                Text("적용")
            }
            Spacer(minLength: 0)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
