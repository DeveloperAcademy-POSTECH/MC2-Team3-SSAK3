//
//  DayContainer.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/14.
//

import Foundation

struct DayContainer: Identifiable {
    let id = UUID().uuidString
    let day: Int
    let date: Date
    let monthType: MonthType
}

enum MonthType {
    // 한 달 이내의 날짜
    case participable
    // 한 달 이전 혹은 이후의 날짜
    case unparticipable
}
