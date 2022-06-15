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
    @EnvironmentObject private var userViewModel: Authentication
    @State private var showActionSheet: Bool = false
    @State private var showPicker: Bool = false
    @State private var nicknameContainer: String = "" // User 닉네임을 임시로 담는 변수
    @State private var imageContainer: String? // User 프로필 사진 URL을 임시로 담는 변수
    @State private var selectedImage: UIImage? // 피커에서 선택한 사진을 담는 변수
    @State private var imageData: Data? // 피커에서 선택한 사진을 Data로 변환한 것을 담는 변수
    @State private var isProfileDeleted: Bool = false
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
                TextField("", text: $nicknameContainer)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
            }
            Button {
                guard let user = userViewModel.user else { return }
                if nicknameContainer != user.nickname { // 닉네임 바꿨으면 변경
                    userViewModel.updateNickname(nicknameContainer)
                }
                if let newImage = imageData { //
                    userViewModel.updateProfileImage(newImage)
                } else if isProfileDeleted {
                    userViewModel.deleteProfileImage()
                    isProfileDeleted = false
                }
            } label: {
                Text("적용")
            }
            .disabled(nicknameContainer.contains(" ") || nicknameContainer == "")
            Spacer(minLength: 0)
        }
        .onAppear {
            if let user = userViewModel.user {
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
                .foregroundColor(.white)
                .font(.system(size: diameter/1.5))
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
            imageData = nil
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
