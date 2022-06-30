//
//  CalendarHelper.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/14.
//

import Foundation

class CalendarHelper {
    // 해당 달 에서의 날짜 계산
    func getExactDates(_ currentMonth: Int) -> [DayContainer] {
        let calendar = Calendar.current
        let current = changeCurrentMonth(currentMonth)
        let components = calendar.dateComponents([.year, .month], from: current)
        let firstDayIndexOfWeek = calendar.component(.weekday, from: calendar.date(from: components) ?? Date())
        guard let muteDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else { return [] }
        guard let currentMonthDays = current.monthlyDayCount else { return [] }

        var thisMonthDates = current.monthDates.map { date -> DayContainer in
            guard let day = date.day else { return DayContainer(day: 0, date: date, monthType: .unparticipable) }
            return DayContainer(day: day, date: date, monthType: date.monthType)
        }

        for _ in 0..<firstDayIndexOfWeek - 1 {
            thisMonthDates.insert(DayContainer(day: 0, date: muteDate, monthType: .unparticipable), at: 0)
        }
        appendOneWeek(firstDayIndexOfWeek, currentMonthDays, &thisMonthDates)

        return thisMonthDates
    }

    // 화살표 이동에 따른 달 이동
    func changeCurrentMonth(_ currentMonth: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: currentMonth, to: Date()) ?? Date()
    }

    // 다섯줄의 달력을 여섯줄로 만들기 위해 임의의 데이터를 넣어주는 작업
    func appendOneWeek(_ firstDayOfWeek: Int, _ monthlyDayCount: Int, _ monthDates: inout [DayContainer]) {
        guard let muteDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else { return }
        let lastDayIndex = firstDayOfWeek - 1 + monthlyDayCount
        if lastDayIndex < 42 {
            for _ in 0..<(42 - lastDayIndex) {
                monthDates.insert(DayContainer(day: 0, date: muteDate, monthType: .unparticipable), at: monthDates.endIndex)
            }
        }
    }

}
