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
    @State private var renderedDate: Date?
    @StateObject private var taxiPartyListViewModel: TaxiPartyListViewModel = TaxiPartyListViewModel()
    @State var selectedIndex: Int = 0

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack {
                    TaxiPartyHeadLine()
                    HStack {
                        TaxiPartyFiltering(selectedIndex: $selectedIndex)
                        Spacer()
                        DatePickerButton(showModal: $showModal)
                    }
                }
                .padding(.horizontal, 20)
                ScrollViewReader { proxy in
                ScrollView {
                    CellViewList(selectedIndex: $selectedIndex, taxiParties: taxiPartyListViewModel.taxiPartyList)
                }
                 .onChange(of: renderedDate) { _ in
                    guard let date = renderedDate else { return }
                     withAnimation {
                         proxy.scrollTo(date.formattedInt, anchor: .top)
                     }
                    renderedDate = nil
                }
                }
                .refreshable {
                    await fetchSomething()
                }
                .background(Color.background)
            }
            CalendarModal(isShowing: $showModal, renderedDate: $renderedDate, taxiPartyList: filterCalender())
        }
        .onAppear {
            taxiPartyListViewModel.getTaxiParties(id: nil)
        }
    }
    func fetchSomething() async {
        try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
    }

    private func filterCalender() -> [TaxiParty] {
        switch selectedIndex {
        case 0:
            return taxiPartyListViewModel.taxiPartyList
        case 1:
            return taxiPartyListViewModel.taxiPartyList.filter({ taxiParty in
                return taxiParty.destinationCode == 1
            })
        case 2:
        return taxiPartyListViewModel.taxiPartyList.filter({ taxiParty in
            return taxiParty.destinationCode == 0
        })
        default:
            return taxiPartyListViewModel.taxiPartyList
        }
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
    @Binding var selectedIndex: Int

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
    @Binding var selectedIndex: Int

    let taxiParties: [TaxiParty]
    private var totalParties: [Int: [TaxiParty]] {
        Dictionary.init(grouping: taxiParties, by: {$0.meetingDate})
    }
    private var destFilteredParties: [Int: [TaxiParty]] {
        Dictionary.init(grouping: taxiParties, by: {$0.destinationCode})
    }
    private var totalMeetingDates: [Int] {
        totalParties.map({$0.key}).sorted()
    }

    private var ktxFilteredParties: [Int: [TaxiParty]] {
        guard let parties = destFilteredParties[1] else {
            return [:]}
        return Dictionary.init(grouping: parties, by: {$0.meetingDate})
    }

    private var ktxMeetingDates: [Int] {
        return ktxFilteredParties.map({$0.key}).sorted()
    }

    private var postechFilteredParties: [Int: [TaxiParty]] {
        guard let parties = destFilteredParties[0] else {
            return [:]}
        return Dictionary.init(grouping: parties, by: {$0.meetingDate})
    }

    private var postechMeetingDates: [Int] {
        return postechFilteredParties.map({$0.key}).sorted()
    }

    var body: some View {
        if isRefreshing {
            MyProgress()
                .transition(.scale)
        }
        LazyVStack(spacing: 16) {
            ForEach(mappingDate(), id: \.self) { date in
                Section(header: SectionHeaderView(date: date).id(date)) {
                    ForEach(mappingParties()[date]!, id: \.id) { party in
                        PatyListCell(party: party)
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

    private func mappingDate() -> [Int] {
        switch selectedIndex {
        case 0:
            return totalMeetingDates
        case 1:
            return ktxMeetingDates
        case 2:
            return postechMeetingDates
        default:
            return totalMeetingDates
        }
    }

    private func mappingParties() -> [Int: [TaxiParty]] {
        switch selectedIndex {
        case 0:
            return totalParties
        case 1:
            return ktxFilteredParties
        case 2:
            return postechFilteredParties
        default:
            return totalParties
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
