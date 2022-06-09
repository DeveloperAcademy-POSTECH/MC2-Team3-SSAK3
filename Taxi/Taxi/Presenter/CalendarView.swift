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

    var body: some View {
        VStack {
            header
            datePicker
        }
    }

    // MARK: - view property

    var header: some View {
        var navigation: some View {
            HStack {
                Text("\(currentDate.formattedString)")
                Spacer()
                Button {
                    currentMonth -= 1
                } label: {
                    Image(systemName: "chevron.left")
                }
                Button {
                    currentMonth += 1
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.bottom, 20)
            .padding(.horizontal)
        }

        var dayOfWeek: some View {
            let days = ["월", "화", "수", "목", "금", "토", "일"]
            return HStack {
                ForEach(days, id: \.self) {day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                }
            }
        }

        return VStack {
                navigation
                dayOfWeek
            }
    }

    var datePicker: some View {
        let column = Array(repeating: GridItem(.flexible()), count: 7)

        return LazyVGrid(columns: column) {
            ForEach(getExactDates()) {data in
                Text("\(data.day)")
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
    private func getExactDates() -> [DayStruct] {
        let calendar = Calendar.current
        let current = changeCurrentMonth()
        let components = calendar.dateComponents([.year, .month], from: current)

        let firstDayIndexOfMonth = calendar.component(.weekday, from: calendar.date(from: components) ?? Date())

        var thisMonthDates = currentDate.getMonthDates().map { date in
            DayStruct(day: date.day, date: date, monthType: .participable)
        }

        for _ in 0..<firstDayIndexOfMonth - 1 {
            thisMonthDates.insert(DayStruct(day: -1, date: Date(), monthType: .unparticipable), at: 0)
        }

        return thisMonthDates
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
