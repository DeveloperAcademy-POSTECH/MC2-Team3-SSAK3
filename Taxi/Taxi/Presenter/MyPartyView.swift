//
//  MyPartyView.swift
//  Taxi
//
//  Created by 이윤영 on 2022/06/12.
//

import SwiftUI

struct MyPartyView: View {
    @State var isSwiped: Bool = false // Swipe to Delete가 활성화 되어있는지 확인
    // Dummy Data
    @State var mypartys: [TaxiParty] = [
        TaxiParty(id: "1", departureCode: 0, destinationCode: 1, meetingDate: 20220610, meetingTime: 1315, maxPersonNumber: 4, members: ["1", "2", "3", "4"], isClosed: true),
        TaxiParty(id: "2", departureCode: 0, destinationCode: 1, meetingDate: 20220611, meetingTime: 1330, maxPersonNumber: 3, members: ["1", "3"], isClosed: false),
        TaxiParty(id: "3", departureCode: 0, destinationCode: 1, meetingDate: 20220611, meetingTime: 1440, maxPersonNumber: 3, members: ["1", "2", "3"], isClosed: false),
        TaxiParty(id: "4", departureCode: 0, destinationCode: 1, meetingDate: 20220612, meetingTime: 1734, maxPersonNumber: 3, members: ["1", "2"], isClosed: false),
        TaxiParty(id: "5", departureCode: 0, destinationCode: 1, meetingDate: 20220612, meetingTime: 2005, maxPersonNumber: 2, members: ["1"], isClosed: false),
        TaxiParty(id: "6", departureCode: 0, destinationCode: 1, meetingDate: 20220617, meetingTime: 1340, maxPersonNumber: 4, members: ["1", "3"], isClosed: false)
    ]
    private var partys: [Int: [TaxiParty]] {
        Dictionary.init(grouping: mypartys, by: {$0.meetingDate})
    }
    private var meetingDates: [Int] {
        partys.map({$0.key}).sorted()
    }
    private var cancelSelectDrag : some Gesture {
        DragGesture()
            .onChanged { _ in
                isSwiped = false
            }
    }
    private var cancelSelectTap : some Gesture {
        TapGesture()
            .onEnded {
                isSwiped = false
            }
    }
    var body: some View {
        VStack {
            TitleView()
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16, pinnedViews: [.sectionHeaders]) {
                    ForEach(meetingDates, id: \.self) { date in
                        Section(header: SectionHeaderView(date: date)) {
                            ForEach(partys[date]!, id: \.id) { party in
                                NavigationLink {
                                    ChatRoomView(party: party)
                                } label: {
                                    CellView(party: party)
                                }
                                .disabled(isSwiped)
                                .swipeDelete(isSwiped: $isSwiped, action: {
                                    print("나가기")
                                })
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 0)
                                .buttonStyle(.plain)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .highPriorityGesture(isSwiped ? cancelSelectDrag : nil)
            .simultaneousGesture(isSwiped ? cancelSelectTap : nil)
            .background(Color.lightGray) // TODO: 색상 변경
        }
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
        case .swiping(let width):
            return width
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
    @State var swipeState = SwipeActionState.inactive
    @GestureState var isDragging = false
    private var swipeAction: some Gesture {
        DragGesture(coordinateSpace: .local)
            .updating($isDragging) { _, state, _ in
                state = true
            }
            .onChanged { value in
                if value.translation.width < 0 {
                    swipeState = SwipeActionState.swiping(width: value.translation.width)
                }
            }
            .onEnded { value in
                if value.translation.width < 0 {
                        swipeState = SwipeActionState.active
                        isSwiped = true
                }
            }
    }
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.red)
            HStack {
                Spacer()
                Text("나가기")
                    .frame(width: 75)
                    .foregroundColor(.white)
                    .gesture(TapGesture().onEnded({self.action()}))
                    .offset(x: 75 + swipeState.width)
            }
            content
                .frame(maxWidth: .infinity)
                .background(.white)
                .offset(x: swipeState.width)
                .highPriorityGesture(swipeAction)
        }
        .onChange(of: isDragging) { _ in
            if isDragging == false && swipeState.isSwiping {
                swipeState = SwipeActionState.inactive
            }
        }
        .onChange(of: isSwiped) { _ in
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

struct TitleView: View {
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

struct SectionHeaderView: View {
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

struct MyPartyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MyPartyView()
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}
