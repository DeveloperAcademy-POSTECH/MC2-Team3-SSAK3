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
}
struct AddTaxiParty: View {
    @Environment(\.dismiss) private var dismiss
    @State private var step: AddTaxiParty.Step = .destination // 현재 정보 입력 단계
    @State private var destination: Place? // 목적지
    @State private var startDate: String? // 출발 날짜
    @State private var startHour: Int? // 출발 시간
    @State private var startMinute: Int? // 출발 분
    @State private var departure: Place? // 출발 장소
    @State private var maxNumber: Int? // 정원

    private let columns: [GridItem] = [GridItem(.flexible(minimum: 60, maximum: 200)), GridItem(.flexible(minimum: 60, maximum: 200)), GridItem(.flexible(minimum: 60, maximum: 200))]

    private var hourRange: Range<Int> {
        // TODO: 출발 날짜가 오늘과 같으면, 현재 시간 이후로만 모임 시간이 떠야함
        if startDate == "" {
            return Calendar.current.component(.hour, from: Date())..<24
        }
        // 출발 날짜가 오늘이 아니면, 0시부터 23시까지 모임 시간이 뜬다.
        else {
            return 0..<24
        }
    }

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
// MARK: Step 변경 로직
extension AddTaxiParty {
    // 사용자가 정보 수정을 위해 임의로 탭을 입력하는 경우
    private func changeStep(to step: AddTaxiParty.Step) {
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
    private func toNextStep() {
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
    private func checkAllInfoSelected() -> Bool {
        return destination != .none && destination != nil && startDate != nil && startHour != nil && startMinute != nil && departure != nil && maxNumber != nil
    }
}
// MARK: - 프리뷰
struct AddTaxiParty_Previews: PreviewProvider {
    static var previews: some View {
        AddTaxiParty()
    }
}
