//
//  PostView.swift
//  Planterior_App
//
//  Created by  Isac Park on 2022/05/03.
//

import SwiftUI

struct CalendarModal: View {
    @Binding var isShowing: Bool
    @Binding var renderedDate: Date?
    @State var uiTabarController: UITabBarController?
    @State private var storeDate: Date?
    @State private var toastIsShowing = false
    @State private var isPresented = false
    @State private var curHeight: CGFloat = 400
    let taxiPartyList: [TaxiParty]

    var body: some View {
        ZStack(alignment: .bottom) {
            if isShowing {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        modalCloseHandling()
                    }
                VStack {
                    if toastIsShowing {
                        toastMessage
                    }
                    mainView
                }
                .transition(.move(edge: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .introspectTabBarController { (UITabBarController) in
            if isShowing {
                    UITabBarController.tabBar.isHidden = true
                    uiTabarController = UITabBarController
            }
                }
        .onDisappear {
                    uiTabarController?.tabBar.isHidden = false
                }
    }

    var mainView: some View {
        VStack {
            sheetHeader
                .padding([.bottom, .top], 15)
            CalendarView(taxiParties: taxiPartyList) {isTaxiParty, selectedDate in
                if isTaxiParty {
                    withAnimation {
                        toastIsShowing = false
                    }
                    storeDate = selectedDate
                } else {
                    storeDate = nil
                    withAnimation {
                        toastIsShowing = true
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                            withAnimation {
                                toastIsShowing = false
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            Rectangle()
                .cornerRadius(10)
                .foregroundColor(.background)
        )
    }

    var sheetHeader: some View {
        HStack {
            Button {
                modalCloseHandling()
            } label: {
                Text("닫기")
            }
            Spacer()
            Text("날짜를 선택해주세요")
            Spacer()
            Button {
                uiTabarController?.tabBar.isHidden = false
                withAnimation {
                    isShowing.toggle()
                }
                renderedDate = storeDate
                storeDate = nil
            } label: {
                Text("확인")
            }
            .disabled(storeDate == nil)
        }
    }

    var toastMessage: some View {
        Text("해당 날짜에 생성된 택시팟이 없어요")
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
            )
            .padding()
    }

    // MARK: - Function
    private func modalCloseHandling() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            uiTabarController?.tabBar.isHidden = false
        }
        uiTabarController?.tabBar.isHidden = false
        toastIsShowing = false
        storeDate = nil
        withAnimation(.easeInOut) {
            isShowing = false
        }

    }
}

struct CalendarModalView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarModal(isShowing: .constant(true), renderedDate: .constant(Date()), taxiPartyList: [])
    }
}
