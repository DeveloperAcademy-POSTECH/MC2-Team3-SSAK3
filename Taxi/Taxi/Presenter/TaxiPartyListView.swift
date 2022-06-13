//
//  TaxiPartyListView.swift
//  Taxi
//
//  Created by Yosep on 2022/06/09.
//
import SwiftUI

struct TaxiPartyListView: View {
    var body: some View {
        VStack {
            VStack {
                TaxiPartyHeadLine()
                // .padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7))
                HStack {
                    TaxiPartyFiltering()
                    Spacer() // .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    MeetingDateChange()
                }
            }.padding(.vertical, -7.8)
                .padding(.horizontal, 20)
            ZStack {
                ScrollView {
                    CellViewList()
                } .refreshable {     // << injects environment value !!
                    await fetchSomething()
                }
            }.border(Color.gray)
                .background(Color(red: 1 / 255, green: 248 / 255, blue: 248 / 255, opacity: 1.0))
                .ignoresSafeArea()
        }
    }
    func fetchSomething() async {
        // demo, assume we update something long here
        try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
    }
}

struct TaxiPartyHeadLine: View {
    var body: some View {
        HStack {
            Text("택시팟")
            // .font(.system(size: 26))
                .font(.custom("Apple SD Gothic Neo", size: 26))
                .fontWeight(.bold)
            Spacer()
            Button {
                // todo: 채팅방 생성 View로 전환
                print("+ tapped!")
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundColor(.black)
            }
        } // .padding(.horizontal, 20)
    }
}

struct TaxiPartyFiltering: View {
    let titles: [String] = ["전체", "포항역", "포스텍"]
    @State var selectedIndex: Int = 0
    var body: some View {
        SegmentedPicker(
            // todo : CellView 목적지 별로 필터링 가능하게 만들기
            titles,
            selectedIndex: Binding(
                get: { selectedIndex },
                set: { selectedIndex = $0 ?? 0 }),
            content: { item, isSelected in
                Text(item)
                    .foregroundColor(Color.black)
                    .font(.custom("Apple SD Gothic Neo", size: 16))
                    .fontWeight(isSelected ? .semibold : .light)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
            },
            selection: {
                VStack(spacing: 0) {
                    Spacer()
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 50, height: 2)
                }
            })
        .onAppear {
            selectedIndex = 0
        }
        .animation(.easeInOut(duration: 0.3), value: selectedIndex)
    } // Switch 문으로 selectedIndex 별로 나누어 filter 되게끔 동작하게 한다.
}

struct MeetingDateChange: View {
    var body: some View {
        Button {
            // todo: 달력 모달 띄우기
            print("날짜 선택 tapped!")
        } label: {
            Text("날짜 선택")
                .foregroundColor(Color(red: 255 / 255, green: 204 / 255, blue: 18 / 255, opacity: 1.0))
                .font(.custom("Apple SD Gothic Neo", size: 16))
                .fontWeight(.semibold)
        }
    }
}

struct MyProgress: View {
    @State private var isProgress = false
    var body: some View {
        HStack {
            ForEach(0...4, id: \.self) { index in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(Color(red: 255 / 255, green: 204 / 255, blue: 18 / 255, opacity: 1.0))
                    .scaleEffect(self.isProgress ? 1:0.01)
                    .animation(self.isProgress ? Animation .linear(duration: 0.8) .repeatForever() .delay(0.2*Double(index)) : .default, value: isProgress)
            }
        }
        .onAppear { isProgress = true }
        .padding()
    }
}

struct CellViewList: View {
    @Environment(\.refresh) private var refresh   // << refreshable injected !!
    @State private var isRefreshing = false
    var body: some View {
        if isRefreshing {
            MyProgress()    // ProgressView() ?? - no, it's boring :)
                .transition(.scale)
        }
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                ForEach(0..<30, id: \.self) { _ in
                    CellView()
                        .padding(4)
                }
            } .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
        }
        .animation(.default, value: isRefreshing)
        .background(GeometryReader { // detect Pull-to-refresh
            Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .global).origin.y)
        })
        .onPreferenceChange(ViewOffsetKey.self) {
            if $0 < -270 && !isRefreshing {   // << any criteria we want !!
                isRefreshing = true
                Task {
                    await refresh?()           // << call refreshable !!
                    await MainActor.run {
                        isRefreshing = false
                    }
                }
            }
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct TaxiPartyListView_Previews: PreviewProvider {
    static var previews: some View {
        TaxiPartyListView()
    }
}
