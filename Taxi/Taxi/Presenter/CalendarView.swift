//
//  CalendarView.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/09.
//

import SwiftUI

struct CalendarView: View {
    @State private var currentDate = Date()
    @State private var selectedDate = Date()
    @State private var currentMonth = 0
    private let today = Date()
    private let taxiParties: [TaxiParty] = TaxiPartyMockData.mockData
    private let action: () -> Void
    let days = ["일", "월", "화", "수", "목", "금", "토"]
    let intDateConverter = IntDateConverter()

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                navigation
                dayOfWeek
            }
            datePicker
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - view property

    var navigation: some View {
        HStack {
            Text("\(currentDate.formattedString)")
            Spacer()
            Button {
                withAnimation {
                    currentMonth -= 1
                }
            } label: {
                Image(systemName: "chevron.left")
                    .tint(.black)
            }
            Button {
                withAnimation {
                    currentMonth += 1
                }
            } label: {
                Image(systemName: "chevron.right")
                    .tint(.black)
            }
        }
        .padding(.horizontal, 10)
        .onChange(of: currentMonth) {_ in
            currentDate = changeCurrentMonth()
        }
    }

    var dayOfWeek: some View {
        return HStack {
            ForEach(days, id: \.self) {day in
                Text(day)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    var datePicker: some View {
        let column = Array(repeating: GridItem(.flexible()), count: 7)

        return LazyVGrid(columns: column, spacing: 10) {
            ForEach(getExactDates()) {data in
                dayCell(data)
                    .background(
                        Circle()
                            .fill(.yellow)
                            .opacity(data.date.isSameDay(selectedDate) ? 1 : 0)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    )
                    .onTapGesture {
                        selectedDate = data.date
                        guard taxiParties.first(where: {party in
                            data.date.isSameDay(intDateConverter.makeDateType(from: party.meetingDate))
                        }) == nil else { return }
                            action()
                    }
                    .disabled(data.monthType == .unparticipable)
            }
        }
    }

    // MARK: - function

    // 화살표 이동에 따른 달 이동
    private func changeCurrentMonth() -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: currentMonth, to: Date()) ?? Date()
    }

    // 해당 달 에서의 날짜 계산
    private func getExactDates() -> [DayContainer] {
        let calendar = Calendar.current
        let current = changeCurrentMonth()
        let components = calendar.dateComponents([.year, .month], from: current)
        let firstDayIndexOfWeek = calendar.component(.weekday, from: calendar.date(from: components) ?? Date())
        let currentMonthDays = current.monthlyDayCount()

        var thisMonthDates = current.getMonthDates().map { date in
            DayContainer(day: date.day, date: date, monthType: checkMonthType(date))
        }

        for _ in 0..<firstDayIndexOfWeek - 1 {
            thisMonthDates.insert(DayContainer(day: 0, date: Date(), monthType: .unparticipable), at: 0)
        }
        oneWeekAppend(firstDayIndexOfWeek, currentMonthDays, &thisMonthDates)

        return thisMonthDates
    }

    // 다섯줄의 달력을 여섯줄로 만들기 위해 임의의 데이터를 넣어주는 작업
    private func oneWeekAppend(_ firstDayOfWeek: Int, _ monthlyDayCount: Int, _ monthDates: inout [DayContainer]) {
        let lastDayIndex = firstDayOfWeek - 1 + monthlyDayCount
        if lastDayIndex < 36 {
            for _ in 0..<(36 - lastDayIndex) {
                monthDates.insert(DayContainer(day: 0, date: Date(), monthType: .unparticipable), at: monthDates.endIndex)
            }
        }
    }

    // 해당 날짜가 오늘의 날짜와 한달 차이나는지 monthType 결정
    private func checkMonthType(_ date: Date) -> MonthType {
        return date.isOutOfMonth() ? .unparticipable : .participable
    }

    private func dayNumColor(_ comparing: Date, _ compared: Date, color dotColor: Color) -> Color {
        return comparing.isSameDay(compared) ? .white : dotColor
    }

    // MARK: - view maker
    private func dayCell(_ value: DayContainer) -> some View {
        ZStack {
            if value.day != 0 {
                if let taxiParty = taxiParties.first(where: {party in
                    return value.date.isSameDay(intDateConverter.makeDateType(from: party.meetingDate))
                }
                ) {
                    Text("\(value.day)")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(value.date.isOutOfMonth() ? .gray : dayNumColor(selectedDate, intDateConverter.makeDateType(from: taxiParty.meetingDate), color: .black))
                    Circle()
                        .fill(value.date.isOutOfMonth() ? .gray : dayNumColor(selectedDate, intDateConverter.makeDateType(from: taxiParty.meetingDate), color: .green))
                        .opacity(value.date.isOutOfMonth() ? 0 : 1)
                        .frame(width: 5, height: 5)
                        .padding(.top, 30)
                } else {
                    Text("\(value.day)")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(value.date.isOutOfMonth() ? .gray : dayNumColor(value.date, selectedDate, color: .black))
                }
            }
        }
        .frame(height: 50)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(action: {print("hello")})
    }
}
