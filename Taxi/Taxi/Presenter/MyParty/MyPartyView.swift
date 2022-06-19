//
//  MyPartyView.swift
//  Taxi
//
//  Created by 이윤영 on 2022/06/12.
//

import SwiftUI

struct MyPartyView: View {
    @EnvironmentObject private var listViewModel: ListViewModel

    var body: some View {
        VStack {
            MyPartyTitle()
            if listViewModel.myParties.count == 0 {
                EmptyPartyView(tab: Tab.myParty)
            } else {
                MyPartyList()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
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
            .padding([.leading, .top])
    }
}

struct MyPartyList: View {
    @EnvironmentObject private var listViewModel: ListViewModel
    @EnvironmentObject private var authentication: Authentication
    @EnvironmentObject private var appState: AppState
    @State private var isSwiped: Bool = false
    @State private var showAlert: Bool = false
    @State private var selectedParty: TaxiParty?

    private var partys: [Int: [TaxiParty]] {
        Dictionary.init(grouping: listViewModel.myParties, by: {$0.meetingDate})
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
                    ChatRoomView(party: taxiParty, user: authentication.user!)
                }
            } label: {
                EmptyView()
            }
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(meetingDates, id: \.self) { date in
                        Section(header: MyPartySectionHeader(date: date)) {
                            ForEach(partys[date]!, id: \.id) { party in
                                NavigationLink {
                                    ChatRoomView(party: party, user: authentication.user!)
                                } label: {
                                    PartyListCell(party: party)
                                }
                                .buttonStyle(CellButtonStyle())
                                .disabled(isSwiped) // 스와이프 된 상태일 때 비활성화
                                .swipeDelete(isSwiped: $isSwiped, action: {
                                    self.showAlert = true
                                    self.selectedParty = party
                                })
                                .cornerRadius(16)
                                .cellBackground()
                            }
                        }
                    }
                }
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
        listViewModel.leaveMyParty(party: party, user: authentication.user!)
    }
}

struct CellButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.5 : 1)
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

struct EmptyPartyView: View {
    let tab: Tab
    var body: some View {
        VStack {
            Image("TaxiPartyOff")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 133)
            if tab == Tab.taxiParty {
                Text("현재 만들어진 택시팟이 없어요.")
                Text("+ 를 눌러서 택시팟를 생성해보세요.")
            } else {
                Text("현재 참여하고 있는 택시팟이 없어요.")
            }
            Spacer()
        }
        .foregroundColor(.darkGray)
        .padding(.top, 160)
    }
}

struct MyPartyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MyPartyView()
                .environmentObject(Authentication())
                .environmentObject(ListViewModel(userId: ""))
        }
    }
}
