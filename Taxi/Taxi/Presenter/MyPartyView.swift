//
//  MyPartyView.swift
//  Taxi
//
//  Created by 이윤영 on 2022/06/12.
//

import SwiftUI

struct MyPartyView: View {
    @StateObject private var myPartyViewModel: MyPartyViewModel = MyPartyViewModel()
    // TODO: 현재 로그인한 유저 불러오기
    private let user: User = User(id: "123456", nickname: "Jerry", profileImage: nil)

    var body: some View {
        VStack {
            MyPartyTitle()
            MyPartyList(user: user, myPartyViewModel: myPartyViewModel)
        }
        .onAppear {
            myPartyViewModel.getMyParties(user: user)
        }
    }
}

struct MyPartyTitle: View {
    var body: some View {
        Text("마이팟")
            .foregroundColor(.customBlack)
            .font(Font.custom("AppleSDGothicNeo-Bold", size: 20))
            .fontWeight(.bold) // TODO: 텍스트 스타일로 변경
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            .background(Color.white)
    }
}

struct MyPartySectionHeader: View {
    let date: Int
    var body: some View {
        Text("\(date / 100 % 100)월 \(date % 100)일")
            .foregroundColor(.charcoal)
            .font(Font.custom("AppleSDGothicNeo-Bold", size: 18))
            .fontWeight(.medium) // TODO: 텍스트 스타일로 변경
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .top])
            .background(Color.lightGray) // TODO: 색상 변경
    }
}

struct MyPartyList: View {
    let user: User
    @ObservedObject var myPartyViewModel: MyPartyViewModel
    @State private var isSwiped: Bool = false
    @State private var showAlert: Bool = false
    @State private var selectedParty: TaxiParty?

    private var partys: [Int: [TaxiParty]] {
        Dictionary.init(grouping: myPartyViewModel.myPartyList, by: {$0.meetingDate})
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
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16, pinnedViews: [.sectionHeaders]) {
                ForEach(meetingDates, id: \.self) { date in
                    Section(header: MyPartySectionHeader(date: date)) {
                        ForEach(partys[date]!, id: \.id) { party in
                            NavigationLink {
                                ChatRoomView(party: party)
                            } label: {
                                CellView(party: party)
                            }
                            .buttonStyle(CellButtonStyle())
                            .disabled(isSwiped) // 스와이프 된 상태일 때 비활성화
                            .swipeDelete(isSwiped: $isSwiped, action: {
                                self.showAlert = true
                                self.selectedParty = party
                            })
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 0)
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .animation(.default, value: partys)
        .background(Color.lightGray) // TODO: 색상 변경
        .highPriorityGesture(isSwiped ? cancelSelectDrag : nil) // 스와이프 된 상태일 때 취소 드래그 활성화
        .simultaneousGesture(isSwiped ? cancelSelectTap : nil) // 스와이프 된 상태일 때 취소 탭 활성화
        .alert("현재 택시팟을 정말 나가시겠어요?", isPresented: $showAlert) {
            Button("나가기", role: .destructive) {
                delete(object: selectedParty!)
            }
            Button("취소", role: .cancel) {}
        } message: {
            Text("지금 나가면 채팅 데이터는 사라져요")
        }
    }

    private func delete(object: TaxiParty?) {
        guard let party = object else {
            print("No selectedParty in \(#file)")
            return
        }
        myPartyViewModel.leaveMyParty(user: user, party: party)
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

// 임시 셀뷰
// TODO: 구현될 셀뷰와 연결
struct CellView: View {
    let party: TaxiParty
    var body: some View {
        VStack {
            HStack {
                Text("\(party.meetingTime)")
                Text("\(party.members.count)/\(party.maxPersonNumber)")
            }
            HStack {
                Text("\(party.departure)")
                Text(">")
                Text("\(party.destincation)")
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
    }
}

// TODO: 비어있을 때 보여 줄 뷰 구성
struct EmptyPartyView: View {
    var body: some View {
        VStack {
            Text("현재 참여중인 채팅 방이 없어요")
            Text("택시팟에서 생성된 팟을 검색하거나 새로 만들 수 있어요")
        }
    }
}
struct MyPartyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MyPartyView()
                .navigationBarHidden(true)
        }
    }
}
