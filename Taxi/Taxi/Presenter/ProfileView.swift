//
//  ProfileView.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/08.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @State private var showActionSheet: Bool = false
    @State private var showPicker: Bool = false
    @State private var selectedImage: UIImage? // 피커에서 선택한 사진을 담는 변수
    @State private var nicknameContainer: String = "" // User 닉네임을 임시로 담는 변수
    @State private var imageContainer: String? // User 프로필 사진 URL을 임시로 담는 변수
    @State private var isProfileDeleted: Bool = false
    private let profileSize: CGFloat = 160

    private let user: User = User(
        id: "1",
        nickname: "Avo",
        profileImage: "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/f202fce4-a5b6-4e40-9f5e-f22eaf4edd87/ProfileDummy.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220611%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220611T030635Z&X-Amz-Expires=86400&X-Amz-Signature=8756de2e65dc2b6f616fb7a697bbebbaf8f779b53e3481e52fb183b4b5709821&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22ProfileDummy.png%22&x-id=GetObject"
    )

    init() {
        self._nicknameContainer = .init(initialValue: user.nickname)
        self._imageContainer = .init(initialValue: user.profileImage)
    }

    var body: some View {
        VStack {
            Button {
                showActionSheet.toggle()
            } label: {
                Group {
                    if let newImage = selectedImage { // 프로필 사진을 변경한 경우
                        Image(uiImage: newImage)
                            .profileCircle(profileSize)
                    } else if let imageURL = imageContainer { // 프로필 사진이 있는 경우
                        WebImage(url: URL(string: imageURL))
                            .profileCircle(profileSize)
                    } else { // 프로필 사진이 없는 경우
                        textProfile(profileSize)
                    }
                }
                .overlay(alignment: .bottom) {
                    Text("편집")
                }
            }
            .confirmationDialog("프로필 사진 설정", isPresented: $showActionSheet) {
                actionSheetButtons
            }
            .sheet(isPresented: $showPicker) {
                photoPicker
            }
            HStack {
                Text("닉네임")
                Spacer()
                TextField("닉네임", text: $nicknameContainer)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
            }
            Button {
                // TODO: Update User Nickname, Profile Image
                // if nicknameContainer != user.nickname { nickname = nicknameContainer }
                // if let newImage = selectedImage { profileImage = Data(newImage) }
                // else if isProfileDeleted { profileImage = nil }
            } label: {
                Text("적용")
            }
            Spacer(minLength: 0)
        }
    }
}

extension ProfileView {

    func textProfile(_ diameter: CGFloat) -> some View {
        ZStack {
            Circle()
                .foregroundColor(.gray)
                .frame(width: diameter, height: diameter)
            Text(nicknameContainer.prefix(1))
                .foregroundColor(.black)
        }
    }

    @ViewBuilder
    var actionSheetButtons: some View {
        Button("앨범에서 사진 선택") {
            showPicker.toggle()
        }
        Button("프로필 사진 제거") {
            isProfileDeleted = true
            imageContainer = nil
            selectedImage = nil
        }
        Button("취소", role: .cancel) {
            showActionSheet = false
        }
    }

    var photoPicker: some View {
        PhotoPicker(filter: .images, limit: 1) { results in
            PhotoPicker.convertToUIImageArray(fromResults: results) { (imagesOrNil, errorOrNil) in
                if let error = errorOrNil {
                    print(error)
                }
                if let images = imagesOrNil {
                    if let first = images.first {
                        selectedImage = first
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
