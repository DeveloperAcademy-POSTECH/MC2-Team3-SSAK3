//
//  PostView.swift
//  Planterior_App
//
//  Created by  Isac Park on 2022/05/03.
//

import SwiftUI

struct CalendarModal: View {
    @Binding var isShowing: Bool
    @State private var isPresented = false
    @State private var curHeight: CGFloat = 400
    private let minHeight: CGFloat = 300
    private let maxHeight: CGFloat = 300
    private let startOpacity: Double = 0.4
    private let endOpacity: Double = 0.8

    var body: some View {
        ZStack(alignment: .bottom) {
            if isShowing {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            isShowing = false
                        }
                    }
                mainView
                    .transition(.move(edge: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
    }

    var mainView: some View {
        VStack {
            ZStack {
                Capsule()
                    .frame(width: 40, height: 6)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.00001))
            NavigationView {
            } // TODO: 차후 달력 컴포넌트와 연동 예정
            .frame(maxHeight: .infinity)
            .padding(.bottom, 35)
        }
        .frame(height: curHeight)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                Rectangle()
                    .frame(height: curHeight / 2)
            }
                .foregroundColor(.white)
        )
    }
}
