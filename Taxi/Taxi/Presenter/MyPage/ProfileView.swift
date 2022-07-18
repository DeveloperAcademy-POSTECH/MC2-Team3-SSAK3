//
//  ProfileView.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/08.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    enum Field {
        case nickname
    }
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userViewModel: Authentication
    @FocusState private var focusField: Field?
    @State private var showActionSheet: Bool = false
    @State private var showPicker: Bool = false
    @State private var nicknameContainer: String = "" // User 닉네임을 임시로 담는 변수
    @State private var imageContainer: String? // User 프로필 사진 URL을 임시로 담는 변수
    @State private var selectedImage: UIImage? // 피커에서 선택한 사진을 담는 변수
    @State private var imageData: Data? // 피커에서 선택한 사진을 Data로 변환한 것을 담는 변수
    @State private var isProfileDeleted: Bool = false
    @State private var isInValidNickname: Bool = true
    private let profileSize: CGFloat = 104

    var body: some View {
        VStack {
            navigationBar
            profileImageEditButton
            nicknameTextField
            Spacer()
        }
        .confirmationDialog("프로필 사진 설정", isPresented: $showActionSheet) {
            actionSheetButtons
        }
        .fullScreenCover(isPresented: $showPicker) {
            photoPicker
        }
        .onAppear {
            if let user = userViewModel.userInfo {
                nicknameContainer = user.nickname
                imageContainer = user.profileImage
            }
        }
    }
}

private extension ProfileView {

    var navigationBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Text("취소")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text("프로필 수정")
                .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
                .foregroundColor(.customBlack)
            applyChangeButton
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
    }

    var profileImageEditButton: some View {
        Button {
            showActionSheet.toggle()
        } label: {
            if let newImage = selectedImage { // 프로필 사진을 변경한 경우
                ZStack {
                Image(uiImage: newImage)
                    .profileCircle(profileSize)
                Image("profileImage_plus")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .opacity(0.8)
                }
            } else if let imageURL = imageContainer { // 프로필 사진이 있는 경우
                ZStack {
                WebImage(url: URL(string: imageURL))
                    .profileCircle(profileSize)
                Image("profileImage_plus")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .opacity(0.8)
                }
            } else { // 프로필 사진이 없는 경우
                ZStack {
                textProfile(profileSize)
                Image("profileImage_plus")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .opacity(0.8)
            }
            }
        }
    }

    func textProfile(_ diameter: CGFloat) -> some View {
        ZStack {
            Circle()
                .strokeBorder(Color.darkGray, lineWidth: 1)
                .frame(width: diameter, height: diameter)
            Text(nicknameContainer.prefix(1))
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
        Button("닫기", role: .cancel) {
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
                        if let data = first.jpegData(compressionQuality: 0.1) {
                            imageData = data
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    var nicknameTextField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("닉네임")
                .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
                .foregroundColor(.darkGray)
            ZStack(alignment: .bottom) {
                TextField("", text: $nicknameContainer)
                    .disableAutocorrection(true)
                    .focused($focusField, equals: .nickname)
                Rectangle()
                    .foregroundColor(focusField == .nickname ? .customYellow : .charcoal)
                    .frame(height: 2)
                    .offset(y: 6)
            }
            if isInValidNickname {
                VStack(alignment: .leading, spacing: 4) {
                    Text("사용할 수 없는 닉네임입니다.")
                        .padding(.top)
                    Text("특수문자와 공백을 제외하고 입력해주세요")
                }
                .font(Font.custom("AppleSDGothicNeo-Regular", size: 14))
                .foregroundColor(.signUpYellowGray)
            }
        }
        .padding(.horizontal)
        .onChange(of: nicknameContainer) { newValue in
            isInValidNickname = newValue.isInValidNickname
        }
    }

    var applyChangeButton: some View {
        Button {
            guard let user = userViewModel.userInfo else { return }
            if nicknameContainer != user.nickname {
                userViewModel.updateNickname(nicknameContainer)
            }
            if let newImage = imageData {
                userViewModel.updateProfileImage(newImage)
            } else if isProfileDeleted {
                userViewModel.deleteProfileImage()
                isProfileDeleted = false
            }
            dismiss()
        } label: {
            Text("저장")
        }
        .disabled(isInValidNickname)
    }
}
