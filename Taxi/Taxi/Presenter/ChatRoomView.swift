//
//  ChatRoomView.swift
//  Taxi
//
//  Created by 이윤영 on 2022/06/13.
//

import SwiftUI

struct ChatRoomView: View {
    @ObservedObject private var viewModel: ChattingViewModel
    @EnvironmentObject private var authentication: Authentication
    private let taxiParty: TaxiParty

    init(party: TaxiParty) {
        self.taxiParty = party
        _viewModel = ObservedObject(initialValue: ChattingViewModel(party))
    }

    var body: some View {
        VStack {
            messageList
            Typing()
        }
        .navigationTitle("\(taxiParty.meetingTime / 100):\(taxiParty.meetingTime % 100) \(taxiParty.destincation)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: toolbar)
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
extension ChatRoomView {
    private var messageList: some View {
        LazyVStack(spacing: 10) {
            ForEach(viewModel.messages, id: \.id) { message in
                makeMessageRow(message)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.addBackground)
    }
}
extension ChatRoomView {
    @ViewBuilder
    private func makeMessageRow(_ message: Message) -> some View {
        switch message.type {
        case .normal:
            normalMessage(message)
        case .entrance:
            entranceMessage(message)
        }
    }

    private func entranceMessage(_ message: Message) -> some View {
        Text("\(Image(systemName: "sparkles"))\(message.body)")
            .inchatNotification()
            .padding(4)
            .background(RoundedRectangle(cornerRadius: 11).fill(Color(red: 223/255, green: 223/255, blue: 223/255)))
    }

    @ViewBuilder
    private func normalMessage(_ message: Message) -> some View {
        Text(message.body)
    }
}
// 입장 채팅
struct EntranceMessage: View {
    let message: Message
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "sparkles")
            Text(message.body)
        }
    }
}

// 메시지 입력 영역
struct Typing: View {
    @State private var typing: String = ""
    @State var textEditorHeight: CGFloat = 0
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack(alignment: .leading) {
                Text(typing)
                    .lineLimit(3)
                    .foregroundColor(.clear)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 5)
                    .lineSpacing(5)
                    .background(GeometryReader { geo in
                        Color.clear.preference(key: ViewHeightKey.self,
                                               value: geo.frame(in: .global).size.height)
                    })
                TextEditor(text: $typing)
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
                print("보내기")
            } label: {
                Circle()
                    .background(Circle().fill(Color.customYellow))
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
                    .environmentObject(Authentication())
            }
        }
    }
}
