//
//  ChatRoomView.swift
//  Taxi
//
//  Created by 이윤영 on 2022/06/13.
//

import SwiftUI

struct ChatRoomView: View {
    let party: TaxiParty
    // 더미 데이터
    private let user: User = User(id: "123456", nickname: "Jerry", profileImage: "")
    private let othersContent: String = "안녕하세요! 저 C5 앞에 도착했어요 :)"
    private let myContent: String = "저도 거의 다 왔어요!\n혹시 캐리어 가지고 계신가요?"

    var body: some View {
        VStack {
            OthersChat(sender: user, content: othersContent, time: "13:16")
            MyChat(content: myContent, time: "13:16")
            EnterChat(nickname: "Joy")
            Spacer()
            Typing()
        }
    }
}

// 내 채팅
struct MyChat: View {
    let content: String
    let time: String
    var body: some View {
        HStack(alignment: .bottom) {
            Spacer()
            Text(time)
                .foregroundColor(.darkGray)
                .font(Font.custom("AppleSDGothicNeo-Regular", size: 8))
                .fontWeight(.light) // TODO: 폰트 스타일 추가
            Text(content)
                .chatStyle()
                .padding(10)
                .background(Color(red: 255/255, green: 224/255, blue: 64/255)) // TODO: clearYellow 색상 추가
                .cornerRadius(10, corners: [.topLeft, .bottomLeft, .bottomRight])
        }
    }
}

// 상대 채팅
struct OthersChat: View {
    let sender: User
    let content: String
    let time: String
    var body: some View {
        HStack(alignment: .top) {
            ProfileImage(sender, diameter: 44)
            VStack(alignment: .leading, spacing: 4) {
                Text(sender.nickname)
                    .foregroundColor(.charcoal)
                    .font(Font.custom("AppleSDGothicNeo-Regular", size: 14))
                    .fontWeight(.regular) // TODO: 폰트 스타일 추가
                HStack(alignment: .bottom) {
                    Text(content)
                        .chatStyle()
                        .padding(10)
                        .background(.white)
                        .cornerRadius(10, corners: [.topRight, .bottomLeft, .bottomRight])
                    Text(time)
                        .foregroundColor(.darkGray)
                        .font(Font.custom("AppleSDGothicNeo-Regular", size: 8))
                        .fontWeight(.light) // TODO: 폰트 스타일 추가
                }
            }
            Spacer()
        }
    }
}

// 입장 채팅
struct EnterChat: View {
    let nickname: String
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "sparkles")
            Text("\(nickname)님이 택시팟에 참가했습니다.")
        }
        .infoChat()
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
                    .strokeBorder(Color.customYellow, lineWidth: 0.5)
                    .background(Circle().foregroundColor(Color(red: 225/225, green: 229/255, blue: 94/255)))
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


// TODO: Extension 이동
// 날짜와 입장에 같이 쓰이는 스타일
struct InfoChat: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .inchatNotification()
            .padding(5)
            .background(Color(red: 223/256, green: 223/256, blue: 223/256)) // TODO: 색상 추가
            .cornerRadius(11)
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

extension View {
    func infoChat() -> some View {
        self.modifier(InfoChat())
    }

    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct ChatRoom_Previews: PreviewProvider {
    static var previews: some View {
        let user: User = User(id: "123456", nickname: "Jerry", profileImage: "")
        let othersContent: String = "안녕하세요! 저 C5 앞에 도착했어요 :)"
        let myContent: String = "저도 거의 다 왔어요!\n혹시 캐리어 가지고 계신가요?"

        VStack {
            OthersChat(sender: user, content: othersContent, time: "13:16")
            MyChat(content: myContent, time: "13:16")
            EnterChat(nickname: "Joy")
            Spacer()
            Typing()
        }
        .background(Color.darkGray)
    }
}
