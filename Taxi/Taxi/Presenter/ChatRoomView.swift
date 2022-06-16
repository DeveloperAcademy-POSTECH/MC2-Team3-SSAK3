//
//  ChatRoomView.swift
//  Taxi
//
//  Created by 이윤영 on 2022/06/13.
//

import SwiftUI

struct ChatRoomView: View {
    @ObservedObject private var viewModel: ChattingViewModel

    private let user: User = User(id: "2", nickname: "호종이", profileImage: nil)
    private let taxiParty: TaxiParty

    init(party: TaxiParty) {
        self.taxiParty = party
        _viewModel = ObservedObject(initialValue: ChattingViewModel(party))
    }

    var body: some View {
        VStack {
            messageList
            Typing(input: $viewModel.input) {
                viewModel.sendMessage(user.id)
            }
        }
        .navigationTitle("\(taxiParty.meetingTime / 100):\(taxiParty.meetingTime % 100) \(taxiParty.destincation)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: toolbar)
        .onAppear {
            viewModel.setMessageChangeListener()
        }
        .onDisappear {
            viewModel.removeMessageChangeListener()
        }
    }
}
// MARK: - Toolbar 모음
extension ChatRoomView {
    @ToolbarContentBuilder
    private func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button {
                // TODO: 채팅방 나가기 유즈케이스 연결
            } label: {
                Text("나가기")
                    .foregroundColor(.customRed)
                    .font(.custom("AppleSDGothicNeo-Bold", size: 14))
            }

        }
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
            }
            .onReceive(viewModel.updateEvent, perform: { force in
                guard let message = viewModel.messages.last else {
                    return
                }
                if force {
                    proxy.scrollTo(message.id, anchor: .bottom)
                }
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color.addBackground)
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
            Text(Date.convertMessageTimeToReadable(from: message.timeStamp))
                .font(.custom("AppleSDGothicNeo-Light", size: 8))
                .foregroundColor(.darkGray)
            Text(message.body)
                .chatStyle()
                .padding(8)
                .background(RoundedCorner(radius: 10, corners: [.topLeft, .bottomLeft, .bottomRight]).fill(Color.clearYellow))
        }
        .padding(.horizontal)
    }

    struct OpponentMessage: View {
        let message: Message
        // TODO: user 정보만 가져오는 뷰모델 생성 후 연결하기
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
                    Text(message.body)
                        .chatStyle()
                        .padding(8)
                        .background(RoundedCorner(radius: 10, corners: [.topRight, .bottomLeft, .bottomRight]).fill(Color.white))
                }
                Text(Date.convertMessageTimeToReadable(from: message.timeStamp))
                    .font(.custom("AppleSDGothicNeo-Light", size: 8))
                    .foregroundColor(.darkGray)
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
    private let sendMessage: () -> Void
    init(input: Binding<String>, sendMessage: @escaping () -> Void) {
        self._input = input
        self.sendMessage = sendMessage
        UITextView.appearance().backgroundColor = .clear
    }

    var body: some View {
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
                    .disableAutocorrection(true)
                    .lineSpacing(5)
                    .frame(maxHeight: textEditorHeight)
                    .padding(.vertical, 5)
                    .mask(Color.lightGray)
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
        }
        .padding(EdgeInsets(top: 8, leading: 10, bottom: 5, trailing: 10))
        .background(.white)
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

struct ChatRoom_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ChatRoomView(party: TaxiPartyMockData.mockData.first!)
            }
        }
    }
}
