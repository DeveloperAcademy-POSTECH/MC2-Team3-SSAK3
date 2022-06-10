//
//  ProfileView.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/08.
//

import SwiftUI

struct ProfileView: View {
    @State private var isPickerPresented: Bool = false
    @State private var nickname: String
    @State private var profileImage: String?

    // Dummy Data
    private var user: User = User(
        id: "id1",
        nickname: "Avo",
        profileImage: "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/f202fce4-a5b6-4e40-9f5e-f22eaf4edd87/ProfileDummy.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220610%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220610T083701Z&X-Amz-Expires=86400&X-Amz-Signature=ec09e76610687de9121ac99b21ac9b186223d94641c8c4abf441d7f6ac8e268c&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22ProfileDummy.png%22&x-id=GetObject"
    )

    init() {
        self.nickname = user.nickname
        self.profileImage = user.profileImage
    }

    var body: some View {
        VStack {
            Button {
                isPickerPresented.toggle()
            } label: {
                Image("ProfileDummy")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 160)
                    .overlay(alignment: .bottom) {
                        Text("편집")
                    }
            }
            .sheet(isPresented: $isPickerPresented) {
                Text("PhotoPicker")
            }
            HStack {
                Text("닉네임")
                Spacer()
                TextField("닉네임", text: $nickname)
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
