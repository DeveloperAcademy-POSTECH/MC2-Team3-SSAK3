//
//  ChatRoomView.swift
//  Taxi
//
//  Created by 이윤영 on 2022/06/13.
//

import Combine
import Introspect
import SwiftUI

struct ChatRoomView: View {
    @EnvironmentObject private var listViewModel: MyPartyView.ViewModel
    @StateObject private var viewModel: ChattingViewModel
    @ObservedObject private var keyboard = KeyboardResponder()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusState: Bool
    @State private var showAlert: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var scrollView: UIScrollView?
    @State private var showTaxiPartyInfo: Bool = false {
        didSet {
            if showTaxiPartyInfo {
                infoXOffset = .zero
            } else {
                infoXOffset = infoWidth
            }
        }
    }
    @State private var typingSize: CGFloat = 0
    @State private var infoXOffset: CGFloat
    private let user: UserInfo
    private let infoWidth: CGFloat = UIScreen.main.bounds.width / 1.2

    init(party: TaxiParty, user: UserInfo) {
        self.user = user
        self._infoXOffset = State(initialValue: infoWidth)
        _viewModel = StateObject(wrappedValue: ChattingViewModel(party))
    }

    var body: some View {
            VStack(spacing: 0) {
                header
                messageList
                    .onTapGesture(perform: hideKeyboard)
                Typing(input: $viewModel.input, focusState: _focusState) {
                    viewModel.sendMessage(user.id)
                }
                .readSize { size in
                    typingSize = size.height
                }
            }
            .disabled(showTaxiPartyInfo)
            .background(Color.addBackground)
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisAppear()
            }
            .onReceive(keyboard.$currentHeight) { height in
                setContentOffsetWhenKeyboardShow(height)
            }
            .overlay {
                if showTaxiPartyInfo {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                }
            }
            .overlay(alignment: .trailing) {
                chattingRoomInfo(viewModel.taxiParty)
            }
            .navigationBarHidden(true)
    }
}

// MARK: - 내부 구현
private extension ChatRoomView {
    func hideKeyboard() {
        if let scrollView = scrollView, focusState == true {
            scrollView.setContentOffset(
                CGPoint(x: 0, y: max(scrollView.contentOffset.y - keyboardHeight + typingSize, 0)),
                animated: true
            )
        }
        focusState = false
    }

    func setContentOffsetWhenKeyboardShow(_ height: CGFloat) {
        if let scrollView = scrollView {
            if height > 0 && keyboardHeight == 0 {
                scrollView.setContentOffset(
                    CGPoint(x: 0, y: scrollView.contentOffset.y + height - typingSize),
                    animated: true
                )
            }
            keyboardHeight = height
        }
    }
}

// MARK: - Chat Room Info
private extension ChatRoomView {

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { value in
                withAnimation(.interactiveSpring()) {
                    if value.translation.width > 0 {
                        infoXOffset = value.translation.width
                    }
                }
            }
            .onEnded { value in
                withAnimation(.easeOut(duration: 0.2)) {
                    if value.predictedEndTranslation.width > 0 {
                        showTaxiPartyInfo = false
                    } else {
                        infoXOffset = 0
                    }
                }
            }
    }

    func chattingRoomInfo(_ taxiParty: TaxiParty) -> some View {
        ChatRoomInfo(taxiParty)
            .frame(width: infoWidth)
            .gesture(dragGesture)
            .offset(x: infoXOffset)
    }
}

// MARK: - 헤더
private extension ChatRoomView {
    var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .contentShape(Rectangle())
        HStack {
                Button {
                    withAnimation(.easeOut(duration: 0.3)) {
                        hideKeyboard()
                        self.showTaxiPartyInfo = true
                    }
                } label: {
                    Image(systemName: "person.fill")
                        .foregroundColor(.black)
                }.frame(maxWidth: .infinity, alignment: .trailing)
                Button {
                    showAlert.toggle()
                } label: {
                    Text("나가기")
                        .foregroundColor(.customRed)
                        .font(.custom("AppleSDGothicNeo-Bold", size: 14))
                }
                .padding()
            }
        }
        .overlay {
                HStack {
                    Text(chattingRoomTitle)
                    Text("\(viewModel.taxiParty.currentMemeberCount)명")
                        .foregroundColor(Color.darkGray)
                }
        }
        .background(Color.addBackground.ignoresSafeArea().shadow(radius: 1))
        .alert("택시팟을 나가시겠어요?", isPresented: $showAlert) {
            Button("나가기", role: .destructive) {
                dismiss()
                listViewModel.leaveMyParty(party: viewModel.taxiParty, user: user)
            }
            Button("취소", role: .cancel) {}
        } message: {
            Text("나가기를 하면 대화내용이 모두 삭제되고\n마이팟 목록에서도 삭제돼요.")
        }
    }

    var chattingRoomTitle: String {
        "\(viewModel.taxiParty.readableMeetingTime) \(viewModel.taxiParty.destination)행"
    }
}
// MARK: - 메시지 리스트
private extension ChatRoomView {
    var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.messages, id: \.id) { message in
                        switch message.type {
                        case .entrance:
                            makeEntranceMessage(message)
                                .id(message.id)
                        case .normal:
                            makeNormalMessage(message)
                                .id(message.id)
                        }
                    }
                }
                .padding(.vertical)
            }
            .onReceive(viewModel.updateEvent, perform: { force in
                guard let message = viewModel.messages.last else {
                    return
                }
                if force {
                    proxy.scrollTo(message.id, anchor: .bottom)
                }
            })
            .introspectScrollView {
                scrollView = $0
            }
        }
    }
}
// MARK: - 메시지 UI
private extension ChatRoomView {

    func makeEntranceMessage(_ message: Message) -> some View {
        Text("\(Image(systemName: "sparkles"))\(message.body)")
            .inchatNotification()
            .padding(4)
            .background(RoundedRectangle(cornerRadius: 11).fill(Color(red: 223/255, green: 223/255, blue: 223/255)))
    }

    @ViewBuilder
    func makeNormalMessage(_ message: Message) -> some View {
        switch message.sender {
        case user.id:
            makeMyMessage(message)
        default:
            OpponentMessage(message: message)
        }
    }

    func makeMyMessage(_ message: Message) -> some View {
        HStack(alignment: .bottom) {
            Spacer()
            Text(message.sendTime)
                .font(.custom("AppleSDGothicNeo-Light", size: 8))
                .foregroundColor(.darkGray)
            Text(message.body)
                .textSelection(.enabled)
                .chatStyle()
                .padding(8)
                .background(RoundedCorner(radius: 10, corners: [.topLeft, .bottomLeft, .bottomRight]).fill(Color.clearYellow))
        }
        .padding(.horizontal)
    }

    struct OpponentMessage: View {
        let message: Message
        @StateObject private var profileViewModel: UserProfileViewModel = UserProfileViewModel()

        init(message: Message) {
            self.message = message
        }
        var body: some View {
            HStack(alignment: .bottom) {
                profileImage
                VStack(alignment: .leading, spacing: 4) {
                    Text(profileViewModel.user?.nickname ?? "알 수 없음")
                        .font(.custom("AppleSDGothicNeo-Regular", size: 14))
                        .foregroundColor(.charcoal)
                    HStack(alignment: .bottom) {
                        Text(message.body)
                            .textSelection(.enabled)
                            .chatStyle()
                            .padding(8)
                            .background(RoundedCorner(radius: 10, corners: [.topRight, .bottomLeft, .bottomRight]).fill(Color.white))
                        Text(message.sendTime)
                            .font(.custom("AppleSDGothicNeo-Light", size: 8))
                            .foregroundColor(.darkGray)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .onAppear {
                if profileViewModel.user == nil {
                    profileViewModel.getUser(message.sender)
                }
            }
        }
        @ViewBuilder
        private var profileImage: some View {
            if let user = profileViewModel.user {
                ProfileImage(user, diameter: 40)
            } else {
                Circle()
                    .fill(.white)
                    .frame(width: 40, height: 40)
            }
        }
    }
}

// 메시지 입력 영역
struct Typing: View {

    @Binding private var input: String
    @State private var textEditorHeight: CGFloat = 0
    @State private var isShowingAccountSetting: Bool = false
    @FocusState private var focusState: Bool
    @StateObject private var accountViewModel: AccountViewModel = .init()

    private let sendMessage: () -> Void

    init(input: Binding<String>, focusState: FocusState<Bool>, sendMessage: @escaping () -> Void) {
        self._input = input
        self._focusState = focusState
        self.sendMessage = sendMessage
        UITextView.appearance().backgroundColor = .clear
    }

    var body: some View {
        HStack(alignment: .bottom) {
            Button {
                if let account = accountViewModel.account {
                    input = account.description
                    sendMessage()
                    return
                }
                isShowingAccountSetting = true
            } label: {
                Image(systemName: "banknote")
                    .imageScale(.medium)
                    .padding(9)
                    .background(Circle().fill(Color.lightGray))
            }
            ZStack(alignment: .bottomTrailing) {
                ZStack(alignment: .leading) {
                    Text(input)
                        .lineLimit(3)
                        .foregroundColor(.clear)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 5)
                        .lineSpacing(5)
                        .background(GeometryReader { geo in
                            Color.clear.preference(key: ViewHeightKey.self,
                                                   value: geo.frame(in: .global).size.height)
                        })
                    TextEditor(text: $input)
                        .colorMultiply(.lightGray)
                        .disableAutocorrection(true)
                        .lineSpacing(5)
                        .frame(maxHeight: textEditorHeight)
                        .padding(.vertical, 5)
                        .focused($focusState)
                }
                .onPreferenceChange(ViewHeightKey.self) { textEditorHeight = $0 }
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 35))
                .background(RoundedRectangle(cornerRadius: 17)
                    .fill(Color.lightGray))

                Button {
                    sendMessage()
                } label: {
                    Circle()
                        .fill(Color.customYellow)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Image(systemName: "arrow.up")
                                .foregroundColor(.customBlack)
                        )
                        .padding([.bottom, .trailing], 5)
                }
                .disabled(input.isEmpty)
            }
        }
        .padding(EdgeInsets(top: 8, leading: 10, bottom: 5, trailing: 10))
        .background(.white)
        .fullScreenCover(isPresented: $isShowingAccountSetting) {
            AccountSetting(viewModel: accountViewModel)
                .background(Color.white)
                .clearBackground()
                .enableDismissGesture($isShowingAccountSetting)
        }
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

// 특정 코너만 둥글게 하기 위한 Extension
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#if DEBUG
struct ChatRoom_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ChatRoomView(party: TaxiPartyMockData.mockData.first!, user: UserInfo(id: "", nickname: "", profileImage: ""))
            }
        }
    }
}
#endif
