//
//  MyPartyView.swift
//  Taxi
//
//  Created by 이윤영 on 2022/06/12.
//

import SwiftUI

// MARK: - Content View
struct MyPartyView: View {
    @ObservedObject private var viewModel: ViewModel
    @EnvironmentObject private var appState: AppState

    init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            MyPartyTitle()
            if viewModel.error == .loadPartiesFail {
                ErrorView(ListError.loadPartiesFail, description: "다시 불러오기") {
                    reload()
                }
            } else if viewModel.myParties.count == 0 {
                ErrorView(ListError.noMyParties, description: "택시팟 참여하러 가기") {
                    appState.showTaxiParties()
                }
            } else {
                MyPartyList(viewModel)
            }
        }
        .alert(isPresented: .constant(viewModel.error == .leavePartyFail), error: viewModel.error) { _ in
            Button("확인") {
                viewModel.error = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func reload() {
        viewModel.getMyTaxiParties(force: true)
    }
}

struct MyPartyTitle: View {
    var body: some View {
        Text("마이팟")
            .font(.custom("AppleSDGothicNeo-Bold", size: 25))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
    }
}

struct MyPartySectionHeader: View {
    let date: Int
    var body: some View {
        Text(Date.convertToKoreanDateFormat(from: date))
            .foregroundColor(.charcoal)
            .font(Font.custom("AppleSDGothicNeo-SemiBold", size: 16))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct MyPartyList: View {
    @ObservedObject private var viewModel: MyPartyView.ViewModel
    @EnvironmentObject private var authentication: UserInfoState
    @EnvironmentObject private var appState: AppState
    @State private var isSwiped: Bool = false
    @State private var showAlert: Bool = false
    @State private var selectedParty: TaxiParty?

    init(_ viewModel: MyPartyView.ViewModel) {
        self.viewModel = viewModel
    }

    private var partys: [Int: [TaxiParty]] {
        Dictionary.init(grouping: viewModel.myParties, by: {$0.meetingDate})
    }
    private var meetingDates: [Int] {
        partys.map({$0.key}).sorted()
    }

    private var cancelSelectDrag : some Gesture {
        DragGesture()
            .onChanged { _ in
                withAnimation(.easeOut) {
                    isSwiped = false
                }
            }
    }
    private var cancelSelectTap : some Gesture {
        TapGesture()
            .onEnded {
                withAnimation(.easeOut) {
                    isSwiped = false
                }
            }
    }

    var body: some View {
        ZStack {
            NavigationLink(isActive: $appState.showChattingRoom) {
                if let taxiParty = appState.currentTaxiParty {
                    ChatRoomView(party: taxiParty, user: authentication.userInfo)
                }
            } label: {
                EmptyView()
            }
            List {
                ForEach(meetingDates, id: \.self) { date in
                    Section(header: MyPartySectionHeader(date: date)) {
                        ForEach(partys[date]!, id: \.id) { party in
                            ZStack {
                                PartyListCell(party: party)
                                NavigationLink {
                                    ChatRoomView(party: party, user: authentication.userInfo)
                                        .environmentObject(self.viewModel)
                                } label: {
                                    EmptyView()
                                }
                                .opacity(0)
                            }
                            .disabled(isSwiped) // 스와이프 된 상태일 때 비활성화
                            .swipeDelete(isSwiped: $isSwiped, action: {
                                self.showAlert = true
                                self.selectedParty = party
                            })
                            .contentShape(RoundedRectangle(cornerRadius: 16))
                            .cellBackground()
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .refreshable {
                viewModel.getMyTaxiParties(force: true)
            }
            .animation(.default, value: partys)
            .highPriorityGesture(isSwiped ? cancelSelectDrag : nil) // 스와이프 된 상태일 때 취소 드래그 활성화
            .simultaneousGesture(isSwiped ? cancelSelectTap : nil) // 스와이프 된 상태일 때 취소 탭 활성화
            .alert("택시팟을 나가시겠어요?", isPresented: $showAlert) {
                Button("나가기", role: .destructive) {
                    delete(object: selectedParty!)
                }
                Button("취소", role: .cancel) {}
            } message: {
                Text("나가기를 하면 대화내용이 모두 삭제되고\n마이팟 목록에서도 삭제돼요.")
            }
        }
    }

    private func delete(object: TaxiParty?) {
        guard let party = object else { return }
        viewModel.leaveMyParty(party: party, user: authentication.userInfo)
    }
}

enum SwipeActionState {
    case inactive
    case active
    case swiping(width: CGFloat)

    var width: CGFloat {
        switch self {
        case .inactive:
            return .zero
        case .active:
            return -75
        case .swiping(let width): // width가 최대 95를 넘지 않게
            if width > -75 {
                return width
            } else {
                return -75 + (20 * width / UIScreen.main.bounds.width)
            }
        }
    }
    var isSwiping: Bool {
        switch self {
        case .swiping:
            return true
        case .inactive, .active:
            return false
        }
    }
}

struct SwipeDelete: ViewModifier {
    @Binding var isSwiped: Bool
    let action : () -> Void
    @State private var swipeState = SwipeActionState.inactive
    @GestureState private var isDragging = false

    private var swipeAction: some Gesture {
        DragGesture(coordinateSpace: .local)
            .updating($isDragging) { _, state, _ in
                state = true
            }
            .onChanged { value in
                if value.translation.width < 0 {
                    withAnimation(.easeInOut) {
                        swipeState = SwipeActionState.swiping(width: value.translation.width)
                    }
                }
            }
            .onEnded { value in
                if value.translation.width < 0 {
                    withAnimation(.easeInOut) {
                        swipeState = SwipeActionState.active
                        isSwiped = true
                    }
                }
            }
    }

    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            HStack {
                Spacer()
                Text("나가기")
                    .padding()
                    .frame(maxWidth: 95, maxHeight: .infinity, alignment: .leading)
                    .gesture(TapGesture().onEnded({self.action()}))
                    .foregroundColor(.white)
                    .background(.red, in: Rectangle())
                    .offset(x: 95 + swipeState.width)
            }
            content
                .frame(maxWidth: .infinity)
                .background(.white)
                .offset(x: swipeState.width)
                .highPriorityGesture(swipeAction)
        }
        .onChange(of: isDragging) { _ in // Drag 제스쳐가 취소됐을 때 스와이프 상태 inactive로 변경
            if isDragging == false && swipeState.isSwiping {
                withAnimation(.easeOut) {
                    swipeState = SwipeActionState.inactive
                }
            }
        }
        .onChange(of: isSwiped) { _ in // 스와이프가 취소됐을 때 스와이프 상태 inactive로 변경
            if isSwiped == false {
                withAnimation(.easeOut) {
                    swipeState = SwipeActionState.inactive
                }
            }
        }
    }
}

extension View {
    func swipeDelete(
        isSwiped: Binding<Bool>,
        action: @escaping () -> Void
    ) -> some View {
        modifier(SwipeDelete(isSwiped: isSwiped, action: action))
    }
}

struct ErrorView: View {
    private let error: ListError
    private let actionDescription: String
    private let action: () -> Void

    init(_ error: ListError, description: String, action: @escaping () -> Void) {
        self.error = error
        self.actionDescription = description
        self.action = action
    }
    var body: some View {
        VStack {
            Image("TaxiPartyOff")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 133)
            Text(error.errorDescription ?? "")
            Text(error.recoverySuggestion ?? "")
            Button(action: action) {
                Text(actionDescription)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .foregroundColor(.customBlack)
                    .background(Color.customYellow)
                    .cornerRadius(16)
            }
            Spacer()
        }
        .foregroundColor(.darkGray)
        .padding(.top, 160)
    }
}

// MARK: - Preview
struct MyPartyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MyPartyView(MyPartyView.ViewModel(userId: ""))
                .inject()
        }
    }
}

