//
//  DateExtension.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/09.
//

import Foundation

extension Date {
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MMM"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }

    var intFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }

    var dateComponents: DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day], from: self)
    }

    var day: Int {
        return self.dateComponents.day ?? -1
    }

    var month: Int {
        return self.dateComponents.month ?? -1
    }

    var year: Int {
        return self.dateComponents.year ?? -1
    }

    var formattedString: String {
        return self.formatter.string(from: self)
    }

    /// date를 yyyyMMdd의 형태로 바꿈
    var formattedInt: Int {
        let formattedStr = self.intFormatter.string(from: self)
        return Int(formattedStr) ?? -1
    }

    func getMonthDates() -> [Date] {
        let calendar = Calendar.current
        guard let startDate = calendar.date(
            from: calendar.dateComponents(
                [.year, .month],
                from: self
            )
        )else { return [] }

        guard let range = calendar.range(of: .day, in: .month, for: startDate)
        else { return [] }

        return range.compactMap { day -> Date in
            calendar.date(byAdding: .day, value: day - 1, to: startDate) ?? Date()
        }
    }

    func isSameDay(_ comparedDate: Date) -> Bool {
        let calendar = Calendar.current

        return calendar.isDate(self, inSameDayAs: comparedDate)
    }
    
    func isToday() -> Bool {
        let calendar = Calendar.current

        return calendar.isDate(self, inSameDayAs: Date())
    }
}
