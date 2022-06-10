//
//  ProfileView.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/08.
//

import SwiftUI

struct ProfileView: View {
    @State private var isPickerPresented: Bool = false

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
                TextField("닉네임", text: .constant(""))
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
