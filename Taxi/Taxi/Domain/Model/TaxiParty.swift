//
//  TaxiParty.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/04.
//

import Foundation

struct TaxiParty: Codable {
    let id: String
    let departureCode: Int
    let destinationCode: Int
    let meetingDate: Int // (YYYYMMdd)
    let meetingTime: Int // (hhmm)
    let maxPersonNumber: Int
    let members: [String]
    let isClosed: Bool
}

extension TaxiParty: CustomStringConvertible {
    var description: String {
        "출발 날짜: \(meetingDate) 출발 시간: \(meetingTime) 출발지: \(Place.of(departureCode).rawValue) 도착지: \(Place.of(destinationCode).rawValue)"
    }
}

extension TaxiParty: Equatable {
    static func == (lhs: TaxiParty, rhs: TaxiParty) -> Bool {
        return
            lhs.id == rhs.id
    }
}

extension TaxiParty {
    var departure: String {
        Place.of(departureCode).rawValue
    }

    var destincation: String {
        Place.of(destinationCode).rawValue
    }
}
