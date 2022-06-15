//
//  DateExtension.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/14.
//

import Foundation

extension Date {
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MMM"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter
    }

    private var monthDayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter
    }

    private var intFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter
    }

    private var messageTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddhhmmss"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter
    }

    private var dateComponents: DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day], from: self)
    }

    var day: Int? {
        return self.dateComponents.day
    }

    var month: Int? {
        return self.dateComponents.month
    }

    var year: Int? {
        return self.dateComponents.year
    }

    var formattedString: String {
        return self.formatter.string(from: self)
    }

    var monthDay: String {
        return self.monthDayFormatter.string(from: self)
    }

    var messageTime: Int {
        return Int(self.messageTimeFormatter.string(from: self))!
    }

    /// date를 yyyyMMdd의 형태로 바꿈
    var formattedInt: Int? {
        let formattedStr = self.intFormatter.string(from: self)
        return Int(formattedStr)
    }

    var monthlyDayCount: Int? {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)
        return range?.count
    }

    var monthDates: [Date] {
        let calendar = Calendar.current
        guard let startDate = calendar.date(
            from: calendar.dateComponents(
                [.year, .month],
                from: self
            )
        ), let range = calendar.range(of: .day, in: .month, for: startDate) else { return [] }

        return range.compactMap { day -> Date in
            calendar.date(byAdding: .day, value: day - 1, to: startDate) ?? Date()
        }
    }

    var isToday: Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: Date())
    }

    // 해당 날짜가 오늘의 날짜와 한달 차이나는지 monthType 결정
    var monthType: MonthType {
        return self.isOutOfMonth ? .unparticipable : .participable
    }

    var isOutOfMonth: Bool {
        let calendar = Calendar.current
        let today = Date()
        let diff = calendar.dateComponents([.day], from: today, to: self).day ?? -1
        let monthlyDayCount = calendar.range(of: .day, in: .month, for: today)?.count ?? 30
        return (diff >= monthlyDayCount || diff < 0 ) ? true : false
    }

    func isSameDay(_ comparedDate: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: comparedDate)
    }

    static func convertToDateFormat(from date: Int) -> Date? {
        let dateStr = String(date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter.date(from: dateStr)
    }

    static func convertToKoreanDateFormat(from date: Int) -> String {
        guard let date = self.convertToDateFormat(from: date), let month = date.month, let day = date.day else { return "" }
        return "\(month)월 \(day)일"
    }
}
