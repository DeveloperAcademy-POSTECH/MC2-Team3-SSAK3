//
//  PostView.swift
//  Planterior_App
//
//  Created by  Isac Park on 2022/05/03.
//

import SwiftUI

struct CalendarModal: View {
    @Binding var isShowing: Bool
    @State private var renderedDate: Date?
    @State private var toastIsShowing = false
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
                VStack {
                    if toastIsShowing {
                        toastMessage
                    }
                    mainView
                    //.transition(.move(edge: .bottom))
                    // TODO: 애니메이션 일단 taxipartylist에서 제거 후 달력 개선
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
    }

    var mainView: some View {
        VStack {
            sheetHeader
                .padding([.bottom, .top], 15)
            CalendarView(taxiParties: TaxiPartyMockData.mockData) {isTaxiParty, selectedDate in
                if isTaxiParty {
                    withAnimation {
                        toastIsShowing = false
                    }
                    renderedDate = selectedDate
                } else {
                    withAnimation {
                        toastIsShowing = true
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                Rectangle()
                    .cornerRadius(10)
            }
                .foregroundColor(.white)
        )
    }

    var sheetHeader: some View {
        HStack {
            Button {
                withAnimation {
                    isShowing.toggle()
                }
            } label: {
                Text("닫기")
            }
            Spacer()
            Text("날짜를 선택해주세요")
            Spacer()
            Button {
                // TODO: scrollview reader scroll to renderedDate
                withAnimation {
                    isShowing.toggle()
                }

            } label: {
                Text("확인")
            }
        }
    }
    
    var toastMessage: some View {
        Text("해당 날짜에 생성된 택시팟이 없어요")
            .padding(EdgeInsets(top: 15, leading: 40, bottom: 15, trailing: 40))

            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
            )
                .frame(maxWidth: .infinity)
            .padding(7)
    }
}

struct CalendarModalView_Previews: PreviewProvider {
    static var previews: some View {
        TaxiPartyListView()
    }
}
