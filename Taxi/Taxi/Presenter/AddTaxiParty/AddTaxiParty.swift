//
//  AddTaxiParty.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/14.
//

import SwiftUI

// MARK: - 정보를 입력하는 각 단계를 지칭하는 enumeration
extension AddTaxiParty {
    enum Step {
        case none
        case destination
        case date
        case time
        case departure
        case personNumber
    }

    enum Selectedhalf: String {
        case morning = "오전"
        case afternoon = "오후"
    }
    static func halfdays() -> [Selectedhalf] {
        [.morning, .afternoon]
    }

}
struct AddTaxiParty: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState
    @State private var step: AddTaxiParty.Step = .destination // 현재 정보 입력 단계
    @State private var destination: Place? // 목적지
    @State private var startDate: Date? // 출발 날짜
    @State private var startHour: Int? // 출발 시간
    @State private var startMinute: Int? // 출발 분
    @State private var departure: Place? // 출발 장소
    @State private var maxNumber: Int? // 정원
    @State private var selectHalfDay: Selectedhalf? = .afternoon // 초기값 오후
    @ObservedObject var viewModel: TaxiPartyList.ViewModel
    @State private var isAdding: Bool = false
    @State private var error: Error?
    let user: UserInfo
    var meetingTime: Int? {
        guard let startHour = startHour, let startMinute = startMinute else { return nil }
        return startHour * 100 + startMinute
    }

    private let columns: [GridItem] = [GridItem(.flexible(minimum: 60, maximum: 200)), GridItem(.flexible(minimum: 60, maximum: 200)), GridItem(.flexible(minimum: 60, maximum: 200))]

    private var hourRange: Range<Int> {
        var todayhour: Int = Calendar.current.component(.hour, from: Date())
        if startDate?.monthDay == Date().monthDay {
            if selectHalfDay == .afternoon {
                if todayhour > 12 {
                return todayhour..<24
                } else {
                    return 12..<24 }
            } else if selectHalfDay == .morning {
                if todayhour < 12 {
                return todayhour..<12
                } else { return 0..<0
                }
            }
            return todayhour..<24
        } else {
            if selectHalfDay == .morning {
                return 0..<12
            } else if selectHalfDay == .afternoon {
                return 12..<24
            }
        }
        return todayhour..<24
    }

    var body: some View {
        ScrollView([]) {
            VStack(alignment: .leading, spacing: 0) {
                closeButton
                destinationSelect
                datePicker
                    .offset(y: -1)
                timePicker
                    .offset(y: -2)
                departurePicker
                    .offset(y: -3)
                personNumberPicker
                    .offset(y: -4)
                Spacer()
                if checkAllInfoSelected() {
                    guideText
                }
                RoundedButton("택시팟 생성", !checkAllInfoSelected(), loading: isAdding) {
                    let taxiParty: TaxiParty = TaxiParty(id: UUID().uuidString, departureCode: departure!.toCode(), destinationCode: destination!.toCode(), meetingDate: startDate!.formattedInt!, meetingTime: (startHour! * 100) + startMinute!, maxPersonNumber: maxNumber!, members: [user.id], isClosed: false)
                    isAdding = true
                    viewModel.addTaxiParty(taxiParty, user: user) { _ in
                        isAdding = false
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            appState.tab = .myParty
                            appState.showToastMessage("택시팟이 생성되었습니다!")
                        }
                    } onError: { error in
                        isAdding = false
                        print(error)
                    }
                }
                .padding()
            }
        }
    }

    private var guideText: some View {
        HStack {
            Spacer()
            Text("해당 사항이 맞으시면 택시팟 생성을 눌러주세요")
                .caption()
                .padding(.bottom, 12)
            Spacer()
        }
    }

    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .imageScale(.large)
                .padding()
        }
    }
}
// MARK: - 여기서부턴 목적지를 설정하는 뷰입니다.
extension AddTaxiParty {
    private var destinationSelect: some View {
        print("destination drawing")
        return HStack(spacing: 16) {
            ForEach(Place.destinations(), id: \.self) { destination in
                destinationItem(destination)
            }
        }
        .padding(EdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16))
        .background(Color.addBackground)
        .toInfoContainer(title: "어디로 가시나요?", selectedInfo: destination?.rawValue ?? "", toggle: step == .destination) {
            changeStep(to: .destination)
        }
    }

    private func destinationItem(_ place: Place) -> some View {
        Button {
            if destination != place {
                destination = place
                departure = nil
                toNextStep()
            }
        } label: {
            Text(place.rawValue)
                .info()
                .padding()
                .frame(maxWidth: .infinity)
                .roundedBackground(destination == place)
        }
    }
}
// MARK: - 날짜 선택 뷰
extension AddTaxiParty {
    private var datePicker: some View {
        CalendarView(action: { _, date in
            startDate = date
            toNextStep()
        })
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
        .toInfoContainer(title: "날짜를 선택해주세요", selectedInfo: startDate?.monthDay ?? "", toggle: step == .date) {
            changeStep(to: .date)
        }
    }
}
// MARK: - 시간 선택 뷰

extension AddTaxiParty {
    
    private var timePicker: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                ForEach(AddTaxiParty.halfdays(), id: \.self) { half in
                    selectHalfDay(half)
            }
            }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            Divider().background(Color.customGray.opacity(0.3))
            hourSelector
            Divider().background(Color.customGray.opacity(0.3))
            minuteSelector
        }
        .background(Color.addBackground)
        .toInfoContainer(title: "몇시에 모이고 싶으신가요?", selectedInfo: convertStartTimeToString(), toggle: step == .time) {
            changeStep(to: .time)
        }
    }
    
    private func selectHalfDay(_ day: Selectedhalf) -> some View {
        Button {
            if selectHalfDay != day {
                selectHalfDay = day
                toNextStep()
            }
                }
        label: {
            Text(day.rawValue)
                .info()
                .padding()
                .frame(maxWidth: .infinity)
                .roundedBackground(selectHalfDay == day)
        }
    }

    private func convertStartTimeToString() -> String {
        if let startHour = startHour, let startMinute = startMinute {
            return "\(startHour)시 \(String(format: "%02d", startMinute))분"
        } else {
            return ""
        }
    }
    private var hourSelector: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 17) {
                ForEach(hourRange, id: \.self) { index in
                    hourItem(index)
                }
            }
            .padding()
        }
    }

    private var minuteSelector: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<6) { minute in
                minuteItem(minute * 10)
            }
        }
        .padding()
    }

    private func selectedTime(_ hour: Int) -> String {
        switch hour {
        case 0...6: return "moon.stars"
        case 7: return "sunrise"
        case 8...17: return "sun.max"
        case 18: return "sunset"
        case 19...23: return "moon.stars"
        default: return ""
        }
    }

    private func hourItem(_ hour: Int) -> some View {
        Button {
            if startHour != hour {
                startHour = hour
                startMinute = nil
            }
        } label: {
            VStack {
                    Image(systemName: selectedTime(hour))
                        .imageScale(.small)
            Text("\(String(hour))시")
                .font(.custom("AppleSDGothicNeo-Medium", size: 18))
            }
            .foregroundColor(startHour == hour ? .customBlack: .charcoal)
            .frame(width: 48, height: 48)
            .roundedBackground(startHour == hour)
        }
    }

    @ViewBuilder
    private func minuteItem(_ minute: Int) -> some View {
        if let startHour = startHour {
            Button {
                startMinute = minute
                toNextStep()
            } label: {
                Text("\(String(format: "%02d", startHour)):\(String(format: "%02d", minute))")
                    .info()
                    .padding(EdgeInsets(top: 10, leading: 26, bottom: 10, trailing: 26))
                    .roundedBackground(startMinute == minute)
            }
        } else {
            Text("00:\(String(format: "%02d", minute))")
                .foregroundColor(.customGray)
                .padding(EdgeInsets(top: 10, leading: 26, bottom: 10, trailing: 26))
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.lightGray))
        }
    }
}
// MARK: - 출발 장소 선택
extension AddTaxiParty {
    private var departurePicker: some View {
        HStack {
            if let destination = destination {
                ForEach(Place.departures(of: destination), id: \.self) { place in
                    Button {
                        departure = place
                        toNextStep()
                    } label: {
                        Text(place.rawValue)
                            .info()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .roundedBackground(departure == place)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 24, leading: 18, bottom: 24, trailing: 18))
        .background(Color.addBackground)
        .toInfoContainer(title: "어디서 모이시나요?", selectedInfo: departure?.rawValue ?? "", toggle: step == .departure) {
            changeStep(to: .departure)
        }
    }
}
// MARK: - 정원 선택
extension AddTaxiParty {
    private var personNumberPicker: some View {
        HStack {
            ForEach(2..<5, id: \.self) { number in
                Button {
                    maxNumber = number
                    toNextStep()
                } label: {
                    Text("\(number)인")
                        .info()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .roundedBackground(maxNumber == number)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 24, leading: 18, bottom: 24, trailing: 18))
        .background(Color.addBackground)
        .toInfoContainer(title: "최대 몇명을 모으고 싶으신가요?", selectedInfo: convertMaxNumberToString(), toggle: step == .personNumber) {
            changeStep(to: .personNumber)
        }
    }

    private func convertMaxNumberToString() -> String {
        if let maxNumber = maxNumber {
            return "\(maxNumber)인"
        } else {
            return ""
        }
    }
}
// MARK: - 선택, 비선택 RoundedRectangle 을 반환하는 함수입니다.
extension AddTaxiParty {
    struct RoundedBackground: ViewModifier {
        private let isSelected: Bool

        init(_ selected: Bool) {
            self.isSelected = selected
        }
        func body(content: Content) -> some View {
            let backgroundColor: Color = isSelected ? .selectYellow : .white
            let strokeColor: Color = isSelected ? .customYellow : .lightGray
            return content.background(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(strokeColor, lineWidth: 1, antialiased: false)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(backgroundColor)
                        .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1))
            )
        }
    }
}
extension View {
    func roundedBackground(_ selected: Bool) -> some View {
        self.modifier(AddTaxiParty.RoundedBackground(selected))
    }
}
// MARK: Step 변경 로직

private extension AddTaxiParty {
  
    // 사용자가 정보 수정을 위해 임의로 탭을 입력하는 경우
    func changeStep(to step: AddTaxiParty.Step) {
        withAnimation(.easeInOut) {
            switch step {
            case .destination:
                // 현재 탭을 닫으려는 경우
                if self.step == step && destination != nil {
                    self.step = .none
                }
                // destination 탭을 열려고 하는 경우 그냥 열어줌
                else {
                    self.step = .destination
                }
            case .date:
                if self.step == step && startDate != nil {
                    self.step = .none
                }
                // date 탭을 열려고 하는 경우 destination 이 정해져야함
                else if destination != nil {
                    self.step = .date
                }
            case .time:
                if self.step == step && startMinute != nil {
                    self.step = .none
                }
                // time 탭을 열려고 하는 경우 date 가 정해져야함
                else if startDate != nil {
                    self.step = .time
                }
            case .departure:
                if self.step == step && departure != nil {
                    self.step = .none
                }
                // departure 탭을 열려고 하는 경우 출발 시간이 정해져야함
                else if startMinute != nil {
                    self.step = .departure
                }
            case .personNumber:
                if self.step == step && maxNumber != nil {
                    self.step = .none
                }
                // personNumber 탭을 열려고 하는 경우 출발장소가 정해져야함
                else if departure != nil {
                    self.step = .personNumber
                }
            default:
                self.step = .none
            }
        }
    }
    // 정보 입력 시 다음 단계로 넘어가는 함수
    func toNextStep() {
        withAnimation(.easeInOut) {
            if checkAllInfoSelected() {
                self.step = .none
            } else {
                if startDate == nil {
                    step = .date
                } else if startMinute == nil {
                    step = .time
                } else if departure == nil {
                    step = .departure
                } else {
                    step = .personNumber
                }
            }
        }
    }

    // 모든 정보가 정상적으로 입력되있는지 확인하는 함수
    func checkAllInfoSelected() -> Bool {
        return destination != .none && destination != nil && startDate != nil && startHour != nil && startMinute != nil && departure != nil && maxNumber != nil
    }
}

#if DEBUG
// MARK: - 프리뷰
struct AddTaxiParty_Previews: PreviewProvider {
    static var previews: some View {
        AddTaxiParty(viewModel: .init(), user: UserInfo(id: "하이", nickname: "하이", profileImage: ""))
            .inject()
    }
}
#endif
