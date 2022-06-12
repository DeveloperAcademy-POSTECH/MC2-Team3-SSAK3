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

        return LazyVGrid(columns: column, spacing: 15) {
            ForEach(getExactDates()) {data in
                dayCell(data)
                    .background(
                        Capsule()
                            .fill(.yellow)
                            .opacity(data.date.isSameDay(selectedDate) ? 1 : 0)
                            .padding(.horizontal, 3)
                    )
                    .onTapGesture {
                        selectedDate = data.date
                        guard taxiParties.first(where: {party in
                            data.date.isSameDay(party.meetingDate.intToDate())
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

        var thisMonthDates = current.getMonthDates().map { date in
            DayContainer(day: date.day, date: date, monthType: checkMonthType(date))
        }

        for _ in 0..<firstDayIndexOfWeek - 1 {
            thisMonthDates.insert(DayContainer(day: 0, date: Date(), monthType: .unparticipable), at: 0)
        }

        return thisMonthDates
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
        VStack {
            if value.day != 0 {
                if let taxiParty = taxiParties.first(where: {party in
                    return value.date.isSameDay(party.meetingDate.intToDate())
                }
                ) {
                    Text("\(value.day)")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(value.date.isOutOfMonth() ? .gray : dayNumColor(selectedDate, taxiParty.meetingDate.intToDate(), color: .black))
                    Circle()
                        .fill(value.date.isOutOfMonth() ? .gray : dayNumColor(selectedDate, taxiParty.meetingDate.intToDate(), color: .green))
                        .opacity(value.date.isOutOfMonth() ? 0 : 1)
                        .frame(width: 8, height: 8)
                } else {
                    Text("\(value.day)")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(value.date.isOutOfMonth() ? .gray : dayNumColor(value.date, selectedDate, color: .black))
                }
            }
        }
        .padding(.top, 5)
        .frame(height: 50, alignment: .top)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(action: {print("hello")})
    }
}
