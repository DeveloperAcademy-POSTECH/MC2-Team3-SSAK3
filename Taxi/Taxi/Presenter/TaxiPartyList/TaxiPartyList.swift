//
//  TaxiPartyList.swift
//  Taxi
//
//  Created by JongHo Park on 2022/08/06.
//

import SwiftUI

// MARK: - List View
struct TaxiPartyList: View {
    @ObservedObject private var viewModel: TaxiPartyList.ViewModel
    @EnvironmentObject private var userState: UserInfoState
    @State private var showTaxiPartyInfo: Bool = false
    @State private var showBlur: Bool = false
    @State private var showAddTaxiParty: Bool = false
    @State private var scrollTo: Date?
    @State private var showCalendarModal: Bool = false

    init(_ viewModel: TaxiPartyList.ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Header(.taxiParty, toolbarItem: .add) {
                    showAddTaxiParty = true
                }
                FilterBar($showCalendarModal) {
                    viewModel.changeFilter($0)
                }
                content()
            }

            CalendarModal(isShowing: $showCalendarModal, renderedDate: $scrollTo, taxiPartyList: viewModel.taxiPartyForCalendar)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .blur(radius: showBlur ? 10 : 0)
        .animation(.easeOut, value: showBlur)
        .fullScreenCover(isPresented: $showAddTaxiParty) {
            AddTaxiParty(viewModel: viewModel, user: userState.userInfo)
        }
    }
}

// MARK: - List View
private extension TaxiPartyList {

    @ViewBuilder
    func content() -> some View {
        switch viewModel.taxiParties {
        case .empty:
            emptyList()
        case .notRequested:
            Spacer()
        case .error(error: let error):
            errorIndicator(error)
        case .loaded(let value):
            loadedView(value)
        case .isLoading:
            loading()
        }
    }
}

// MARK: - content
private extension TaxiPartyList {
    // MARK: - loaded View
    func loadedView(_ taxiParties: [(date: Int, value: [TaxiParty])]) -> some View {
        ScrollViewReader { proxy in
            List {
                ForEach(taxiParties, id: \.date) { list in
                    Section {
                        ForEach(list.value, id: \.id) {
                            Cell(of: $0, $showBlur, viewModel)
                        }
                    } header: {
                        sectionHeader(list.date)
                    }
                    .id(list.date)
                }
            }
            .listStyle(.plain)
            .refreshable {
                viewModel.requestTaxiParties(force: true)
            }
            .onChange(of: scrollTo) { date in
                if let date = date {
                    withAnimation(.interactiveSpring()) {
                        proxy.scrollTo(date.formattedInt, anchor: .top)
                    }
                    scrollTo = nil
                }
            }
        }
    }

    struct Cell: View {
        @State private var isShowTaxiPartyInfo: Bool = false
        @Binding private var showBlur: Bool
        private let taxiParty: TaxiParty
        @ObservedObject private var viewModel: TaxiPartyList.ViewModel
        init(of taxiParty: TaxiParty, _ showBlur: Binding<Bool>, _ viewModel: ViewModel) {
            self._showBlur = showBlur
            self.taxiParty = taxiParty
            self.viewModel = viewModel
        }

        var body: some View {
            PartyListCell(party: taxiParty)
                .cellBackground()
                .onTapGesture {
                    showBlur = true
                    isShowTaxiPartyInfo = true
                }
                .fullScreenCover(isPresented: $isShowTaxiPartyInfo) {
                    showBlur = false
                } content: {
                    TaxiPartyInfo(
                        taxiParty: taxiParty,
                        viewModel: viewModel,
                        showBlur: $showBlur,
                        isShowTaxiPartyInfo: $isShowTaxiPartyInfo
                    )
                }
                .contentShape(RoundedRectangle(cornerRadius: 16))
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 10, trailing: 16))
        }
    }

    func sectionHeader(_ date: Int) -> some View {
        Text(Date.convertToKoreanDateFormat(from: date))
            .foregroundColor(.charcoal)
            .font(Font.custom("AppleSDGothicNeo-SemiBold", size: 16))
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - empty View
    func emptyList() -> some View {
        ZStack {
            List {

            }
            .listStyle(.plain)
            .refreshable {
                viewModel.requestTaxiParties(force: true)
            }
            VStack {
                Spacer()
                Image(ImageName.taxi)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 133)
                Text("현재 만들어진 택시팟이 없어요.\n+ 를 눌러서 택시팟을 생성해보세요.")
                    .subTitleSelect()
                    .multilineTextAlignment(.center)
                Button {
                    showAddTaxiParty = true
                } label: {
                    Text("택시팟 생성하기")
                        .fontWeight(.semibold)
                        .padding(EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24))
                        .background(Color.customYellow, in: RoundedRectangle(cornerRadius: 30))
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    // MARK: - Error View
    func errorIndicator(_ error: Error) -> some View {
        VStack {
            Text("택시팟을 불러오는 도중 에러가 발생했습니다.\n다시 시도해주세요")
                .multilineTextAlignment(.center)
                .padding()
            Button {
                viewModel.requestTaxiParties(force: true)
            } label: {
                Text("다시 시도하기")
                    .fontWeight(.semibold)
                    .padding(EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24))
                    .background(Color.customYellow, in: RoundedRectangle(cornerRadius: 30))
            }
            Spacer()
        }
    }

    func loading() -> some View {
        VStack {
            Spacer()
            ProgressView()
                .frame(width: 40, height: 40, alignment: .center)
            Spacer()
        }
    }
}

#if DEBUG
// MARK: - Preview
struct TaxiPartyList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TaxiPartyList(TaxiPartyList.ViewModel(.empty))
            TaxiPartyList(TaxiPartyList.ViewModel(.error(error: NSError())))
            TaxiPartyList(TaxiPartyList.ViewModel(.empty))
        }
    }
}
#endif
