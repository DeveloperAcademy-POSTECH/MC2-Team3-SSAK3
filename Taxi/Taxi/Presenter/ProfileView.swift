//
//  ProfileView.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/08.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var user: User?
    @State private var showActionSheet: Bool = false
    @State private var showPicker: Bool = false
    @State private var selectedImage: UIImage? // 피커에서 선택한 사진을 담는 변수
    @State private var nicknameContainer: String = "" // User 닉네임을 임시로 담는 변수
    @State private var imageContainer: String? // User 프로필 사진 URL을 임시로 담는 변수
    @State private var isProfileDeleted: Bool = false
    @State private var imageData: Data?
    private let profileSize: CGFloat = 160

    var body: some View {
        VStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .imageScale(.large)
            }
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
        .onAppear {
            if let user = user {
                nicknameContainer = user.nickname
                imageContainer = user.profileImage
            }
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
                        if let data = first.jpegData(compressionQuality: 1) {
                            imageData = data
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
