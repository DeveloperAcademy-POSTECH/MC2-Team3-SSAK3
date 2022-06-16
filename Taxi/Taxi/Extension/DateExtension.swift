//
//  DateExtension.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/14.
//

import Foundation

extension Date {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MMM"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter
    }()

    private static let monthDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter
    }()

    private static let intFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter
    }()

    private static let messageTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddhhmmss"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter
    }()

    private var dateComponents: DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: self)
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

    var hour: Int? {
        return self.dateComponents.hour
    }

    var minute: Int? {
        return self.dateComponents.minute
    }

    var weekday: String {

        guard let weekIndex = self.dateComponents.weekday else { return "" }

        switch weekIndex {
        case 1:
            return "일요일"
        case 2:
            return "월요일"
        case 3:
            return "화요일"
        case 4:
            return "수요일"
        case 5:
            return "목요일"
        case 6:
            return "금요일"
        case 7:
            return "토요일"
        default:
            return ""
        }
    }

    var formattedString: String {
        return Date.formatter.string(from: self)
    }

    var monthDay: String {
        return Date.monthDayFormatter.string(from: self)
    }

    var messageTime: Int {
        return Int(Date.messageTimeFormatter.string(from: self))!
    }

    /// date를 yyyyMMdd의 형태로 바꿈
    var formattedInt: Int? {
        let formattedStr = Date.intFormatter.string(from: self)
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

    func isSameDay(_ comparedDate: Date?) -> Bool {
        let calendar = Calendar.current
        guard let comparedDate = comparedDate else { return false }
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
        return "\(month)월 \(day)일 \(date.weekday)"
    }

    static func convertMessageTimeToReadable(from timeStamp: Int) -> String {
        guard let date = Date.messageTimeFormatter.date(from: String(timeStamp)), let hour = date.hour, let minute = date.minute else {
            return "알 수 없는 시간"
        }
        return "\(hour):\(minute)"
    }
}
