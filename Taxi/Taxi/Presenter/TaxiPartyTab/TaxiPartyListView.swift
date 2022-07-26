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
    @State private var showBlur: Bool = false
    @EnvironmentObject private var listViewModel: ListViewModel
    @EnvironmentObject private var appState: AppState
    @State var selectedIndex: Int = 0
    @State private var showAddTaxiParty: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack {
                    headline
                    HStack {
                        TaxiPartyFiltering(selectedIndex: $selectedIndex)
                        Spacer()
                        DatePickerButton(showModal: $showModal)
                    }
                }
                .padding(.horizontal)
                Divider()
                ScrollViewReader { proxy in
                    ScrollView {
                        CellViewList(selectedIndex: $selectedIndex, showBlur: $showBlur, taxiParties: listViewModel.taxiParties)
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
                    await reload()
                }
                .background(Color.background)
            }
            .alert(isPresented: .constant(listViewModel.error == .outOfMember), error: listViewModel.error) { _ in
                Button("확인") {
                    listViewModel.error = nil
                    listViewModel.getTaxiParties(force: true)
                }
            } message: { error in
                Text(error.recoverySuggestion ?? "")
            }

            CalendarModal(isShowing: $showModal, renderedDate: $renderedDate, taxiPartyList: filterCalender())
        }
        .blur(radius: showBlur ? 10 : 0)
        .animation(.easeOut, value: showBlur)
        .fullScreenCover(isPresented: $showAddTaxiParty, content: {
            AddTaxiParty(user: appState.currentUserInfo!)
        })
        .navigationBarTitleDisplayMode(.inline)
    }

    private func reload() async {
        listViewModel.getTaxiParties(force: true)
        try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
    }

    private func filterCalender() -> [TaxiParty] {
        switch selectedIndex {
        case 0:
            return listViewModel.taxiParties
        case 1:
            return listViewModel.taxiParties.filter({ taxiParty in
                return taxiParty.destinationCode == 1
            })
        case 2:
            return listViewModel.taxiParties.filter({ taxiParty in
                return taxiParty.destinationCode == 0
            })
        default:
            return listViewModel.taxiParties
        }
    }
}

private extension TaxiPartyListView {
    var headline: some View {
        HStack {
            Text("택시팟")
                .font(.custom("AppleSDGothicNeo-Bold", size: 25))
            Spacer()
            Button {
                showAddTaxiParty = true
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
        SegmentedPicker(
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
                .padding(EdgeInsets(top: 8, leading: 11, bottom: 8, trailing: 11))
                .foregroundColor(Color.customBlack)
                .font(.custom("AppleSDGothicNeo-Medium", size: 12))
                .background {
                    RoundedRectangle(cornerRadius: 7.0)
                        .fill(Color.selectYellow)
                }
        }
    }
}

struct MyProgress: View {
    @State private var isProgress = false

    var body: some View {
        HStack {
            Image("YellowTaxi")
                .resizable()
                .frame(width: 25, height: 23)
            ForEach(0...4, id: \.self) { _ in
                Circle()
                    .frame(width: 5, height: 5)
                    .foregroundColor(Color.customYellow)
                    .scaleEffect(self.isProgress ? 1:0.01)
            }
            Image(systemName: "train.side.front.car")
                .font(Font.system(size: 20, weight: .semibold))
                .foregroundColor(.customYellow)
        }
        .onAppear { isProgress = true }
        .padding()
    }
}

struct MyProgressAnimation: View {
    @State private var isProgress = false
    var body: some View {
        VStack {
        HStack {
            Image("YellowTaxi")
                .resizable()
                .frame(width: 25, height: 23)
            ForEach(0...4, id: \.self) { index in
                Circle()
                    .frame(width: 5, height: 5)
                    .foregroundColor(Color.customYellow)
                    .scaleEffect(self.isProgress ? 1:0.01)
                    .animation(self.isProgress ? Animation .linear(duration: 0.8) .repeatForever() .delay(0.2*Double(index)) : .default, value: isProgress)
            }
           Image(systemName: "train.side.front.car")
               .font(Font.system(size: 20, weight: .semibold))
               .foregroundColor(.customYellow)
        }
        .onAppear { isProgress = true }
        .padding()
        }
        Text("택시팟을 불러오고 있어요")
            .foregroundColor(.darkGray)
            .font(.custom("AppleSDGothicNeo-Regular", size: 13))
    }
}

struct CellViewList: View {
    @Environment(\.refresh) private var refresh
    @State private var isRefreshing = false
    @State private var isRefreshingAnimaiton = false
    @Binding var selectedIndex: Int
    @Binding var showBlur: Bool

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
        if isRefreshingAnimaiton {
            MyProgressAnimation()
                .transition(.scale)
        }
        LazyVStack(spacing: 10) {
            if mappingDate().count == 0 {
                EmptyPartyView(tab: Tab.taxiParty)
            } else {
                ForEach(mappingDate(), id: \.self) { date in
                    Section(header: SectionHeaderView(date: date).id(date)) {
                        ForEach(mappingParties()[date]!, id: \.id) { party in
                            Cell(party: party, showBlur: $showBlur)
                        }
                    }
                }
            }
        }
        .padding(.top)
                .animation(.default, value: isRefreshingAnimaiton)
                .background(GeometryReader {
                    Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .global).origin.y)
                })
                .onPreferenceChange(ViewOffsetKey.self) {
                    let heightValueForGesture: CGFloat = 250.0
                    if $0 < -heightValueForGesture && !isRefreshing && !isRefreshingAnimaiton {
                        isRefreshing = true
                    }
                    if $0 > -heightValueForGesture && !isRefreshingAnimaiton && isRefreshing {
                        isRefreshing = false
                        isRefreshingAnimaiton = true
                        Task {
                            await refresh?()
                            await MainActor.run {
                            }
                            isRefreshingAnimaiton = false
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

struct Cell: View {
    let party: TaxiParty
    @State private var showInfoView: Bool = false
    @Binding var showBlur: Bool
    var body: some View {
        Button {
            showInfoView = true
        } label: {
            PartyListCell(party: party)
                .cellBackground()
                .fullScreenCover(isPresented: $showInfoView) {
                    TaxiPartyInfoView(taxiParty: party)
                }
        }
        .onChange(of: showInfoView) { _ in
            showBlur = showInfoView
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
        Text(Date.convertToKoreanDateFormat(from: date))
            .foregroundColor(.charcoal)
            .font(Font.custom("AppleSDGothicNeo-SemiBold", size: 16))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .top])
    }
}

struct TaxiPartyListView_Previews: PreviewProvider {
    static var previews: some View {
        TaxiPartyListView()
            .environmentObject(ListViewModel(userId: ""))
    }
}
