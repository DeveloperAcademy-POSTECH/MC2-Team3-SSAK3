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
    
    var formattedInt: Int {
        let formattedStr = self.intFormatter.string(from: self)
        return Int(formattedStr) ?? -1
    }
    
    /// yyyyMMdd의 Int 형태 데이터를 Date 타입으로 변경
    func intToDate(_ dateInt: Int) -> Date {
        let dateStr = String(dateInt)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        return formatter.date(from: dateStr) ?? Date()
    }
    
    /// yyyyMMdd의 Int 형태 데이터를 MM월 dd
    func intToString(_ dateInt: Int) -> String {
        let date = self.intToDate(dateInt)
        
        return "\(date.month)월 \(date.day)일"
    }
    
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        guard let startDate = calendar.date(
            from:calendar.dateComponents(
                [.year, .month],
                from: self
            )
        ) else { return [] }
        
        guard let range = Calendar.current.range(of: .day, in: .month, for: startDate)
        else { return [] }
        
        return range.compactMap { day -> Date in
            calendar.date(byAdding: .day, value: day - 1, to: startDate) ?? Date()
        }
    }
}
