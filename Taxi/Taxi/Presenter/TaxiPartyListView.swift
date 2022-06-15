//
//  TaxiPartyListView.swift
//  Taxi
//
//  Created by Yosep on 2022/06/09.
//
import SegmentedPicker
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
                }
                .padding(.horizontal, 20)
                ScrollView {
                    CellViewList()
                }
                .refreshable {
                    await fetchSomething()
                }
                .background(Color.background)
            }
            CalendarModal(isShowing: $showModal)
        }
    }
    func fetchSomething() async {
        try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
    }
}

struct TaxiPartyHeadLine: View {
    var body: some View {
        HStack {
            Text("택시팟")
                .font(.custom("AppleSDGothicNeo-Bold", size: 25))
            Spacer()
            Button { // TODO: 채팅방 생성 View로 전환
                print("+ tapped!")
            } label: {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .foregroundColor(.black)
            }
        }
    }
}

struct TaxiPartyFiltering: View {
    private let titles: [String] = ["전체", "포항역", "포스텍"]
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
                    .font(.custom("AppleSDGothicNeo-Regular", size: 16))
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
            }
        )
        .onAppear {
            selectedIndex = 0
        }
        .animation(.easeInOut(duration: 0.3), value: selectedIndex)
    }
}

struct DatePickerButton: View {
    @Binding var showModal: Bool

    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                showModal = true
            }
        } label: {
            Text("날짜 선택")
                .padding(10)
                .foregroundColor(Color.customBlack)
                .font(.custom("AppleSDGothicNeo-Medium", size: 12))
                .background {
                    RoundedRectangle(cornerRadius: 7.0)
                        .fill(Color.customYellow)
                }
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
                    .foregroundColor(Color.customYellow)
                    .scaleEffect(self.isProgress ? 1:0.01)
                    .animation(self.isProgress ? Animation .linear(duration: 0.8) .repeatForever() .delay(0.2*Double(index)) : .default, value: isProgress)
            }
        }
        .onAppear { isProgress = true }
        .padding()
    }
}

struct CellViewList: View {
    @Environment(\.refresh) private var refresh
    @State private var isRefreshing = false
    @State private var mypartys: [TaxiParty] = [
        TaxiParty(id: "1", departureCode: 0, destinationCode: 1, meetingDate: 20220601, meetingTime: 0930, maxPersonNumber: 4, members: ["요셉", "아보", "조이", "제리"], isClosed: true),
        TaxiParty(id: "2", departureCode: 0, destinationCode: 1, meetingDate: 20220601, meetingTime: 1330, maxPersonNumber: 3, members: ["호종이", "아보"], isClosed: false),
        TaxiParty(id: "3", departureCode: 1, destinationCode: 0, meetingDate: 20220602, meetingTime: 1400, maxPersonNumber: 2, members: ["제리", "조이"], isClosed: false),
        TaxiParty(id: "4", departureCode: 0, destinationCode: 1, meetingDate: 20220602, meetingTime: 1734, maxPersonNumber: 3, members: ["호종이", "아보"], isClosed: false),
        TaxiParty(id: "5", departureCode: 0, destinationCode: 1, meetingDate: 20220603, meetingTime: 2005, maxPersonNumber: 2, members: ["요셉"], isClosed: false),
        TaxiParty(id: "6", departureCode: 1, destinationCode: 0, meetingDate: 20220603, meetingTime: 1340, maxPersonNumber: 4, members: ["요셉", "조이"], isClosed: false)
    ]
    private var partys: [Int: [TaxiParty]] {
        Dictionary.init(grouping: mypartys, by: {$0.meetingDate})
    }
    private var meetingDates: [Int] {
        partys.map({$0.key}).sorted()
    }

    var body: some View {
        if isRefreshing {
            MyProgress()
                .transition(.scale)
        }
        ScrollView {
            LazyVStack(spacing: 16, pinnedViews: [.sectionHeaders]) {
                ForEach(meetingDates, id: \.self) { date in
                    Section(header: SectionHeaderView(date: date)) {
                        ForEach(partys[date]!, id: \.id) { party in
                            PatyListCell(party: party)
                        }
                    }
                }
            }
        }
        .padding(.top)
        .animation(.default, value: isRefreshing)
        .background(GeometryReader {
            Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .global).origin.y)
        })
        .onPreferenceChange(ViewOffsetKey.self) {
            let heightValueForGesture: CGFloat = 270.0
            if $0 < -heightValueForGesture && !isRefreshing {
                isRefreshing = true
                Task {
                    await refresh?()
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
            .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .top])
            .background(Color.background)
    }
}

struct TaxiPartyListView_Previews: PreviewProvider {
    static var previews: some View {
        TaxiPartyListView()
    }
}
