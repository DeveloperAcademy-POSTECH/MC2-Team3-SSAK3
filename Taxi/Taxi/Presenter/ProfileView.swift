//
//  ProfileView.swift
//  Taxi
//
//  Created by 민채호 on 2022/06/08.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Circle()
                .foregroundColor(.secondary)
                .frame(width: 160, height: 160)
                .overlay(alignment: .bottom) {
                    Text("편집")
                }
                .onTapGesture {
                    // Edit Profile Image
                }
            HStack {
                Text("닉네임")
                Spacer()
                TextField("닉네임", text: .constant(""))
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
