//
//  DateTypeConverter.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/12.
//

import Foundation

class IntDateConverter {
    func makeDateType(from intDate: Int) -> Date {
        let dateStr = String(intDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")

        return formatter.date(from: dateStr) ?? Date()
    }

    func makeStringDateLabel(from intDate: Int) -> String {
        let date = self.makeDateType(from: intDate)
        return "\(date.month)월 \(date.day)일"
    }
}
