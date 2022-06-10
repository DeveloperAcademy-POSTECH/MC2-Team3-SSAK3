//
//  IntExtension.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/10.
//

import Foundation

extension Int {
    /// yyyyMMdd의 Int 형태 데이터를 Date 타입으로 변경
    func intToDate() -> Date {
        let dateStr = String(self)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")

        return formatter.date(from: dateStr) ?? Date()
    }

    /// yyyyMMdd의 Int 형태 데이터를 MM월 dd
    func intToString() -> String {
        let date = self.intToDate()

        return "\(date.month)월 \(date.day)일"
    }
}
