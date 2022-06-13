//
//  TaxiPartyListView.swift
//  Taxi
//
//  Created by Yosep on 2022/06/09.
//
import SwiftUI

struct TaxiPartyListView: View {
    @State private var showModal = false
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack {
                    TaxiPartyHeadLine()
                    HStack {
                        TaxiPartyFiltering()
                        Spacer()
                        DatePickerButton(showModal: $showModal)
                    }
                } .padding(.horizontal, 20)
                ScrollView {
                    CellViewList()
                } .refreshable {     // << injects environment value !!
                    await fetchSomething()
                }.background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255, opacity: 1.0))
            }
            CalendarModal(isShowing: $showModal)
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
                // TODO: 채팅방 생성 View로 전환
                print("+ tapped!")
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundColor(.black)
            }
        }
    }
}

struct TaxiPartyFiltering: View {
    let titles: [String] = ["전체", "포항역", "포스텍"]
    @State var selectedIndex: Int = 0
    var body: some View {
        SegmentedPicker( // TODO : CellView 목적지 별로 필터링 가능하게 만들기
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

struct DatePickerButton: View {
    @Binding var showModal: Bool
    var body: some View {
        Button(action: { showModal = true }){
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
    @State var mypartys: [TaxiParty] = [
        TaxiParty(id: "1", departureCode: 0, destinationCode: 1, meetingDate: 20220601, meetingTime: 0930, maxPersonNumber: 4, members: ["요셉", "아보", "조이", "제리"], isClosed: true),
        TaxiParty(id: "2", departureCode: 0, destinationCode: 1, meetingDate: 20220601, meetingTime: 1330, maxPersonNumber: 3, members: ["호종이", "아보"], isClosed: false),
        TaxiParty(id: "3", departureCode: 0, destinationCode: 1, meetingDate: 20220602, meetingTime: 1400, maxPersonNumber: 2, members: ["제리", "조이"], isClosed: false),
        TaxiParty(id: "4", departureCode: 0, destinationCode: 1, meetingDate: 20220602, meetingTime: 1734, maxPersonNumber: 3, members: ["호종이", "아보"], isClosed: false),
        TaxiParty(id: "5", departureCode: 0, destinationCode: 1, meetingDate: 20220603, meetingTime: 2005, maxPersonNumber: 2, members: ["요셉"], isClosed: false),
        TaxiParty(id: "6", departureCode: 0, destinationCode: 1, meetingDate: 20220603, meetingTime: 1340, maxPersonNumber: 4, members: ["요셉", "조이"], isClosed: false)
    ]
    private var partys: [Int: [TaxiParty]] {
        Dictionary.init(grouping: mypartys, by: {$0.meetingDate})
    }
    private var meetingDates: [Int] {
        partys.map({$0.key}).sorted()
    }
    var body: some View {
        if isRefreshing {
            MyProgress()    // ProgressView() ?? - no, it's boring :)
                .transition(.scale)
        }
        ScrollView {
            LazyVStack(spacing: 16, pinnedViews: [.sectionHeaders]) {
                ForEach(meetingDates, id: \.self) { date in
                    Section(header: SectionHeaderView(date: date)) {
                        ForEach(partys[date]!, id: \.id) { party in
                            CellView(party: party)
                        }
                    }
                }
            }
        }
        .padding(.top)
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

struct SectionHeaderView: View {
    let date: Int
    var body: some View {
        Text("\(date / 100 % 100)월 \(date % 100)일")
            .foregroundColor(.black)
            .font(Font.custom("AppleSDGothicNeo-Bold", size: 18))
            .fontWeight(.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .top])
            .background(Color.mint)
    }
}

struct TaxiPartyListView_Previews: PreviewProvider {
    static var previews: some View {
        TaxiPartyListView()
    }
}
