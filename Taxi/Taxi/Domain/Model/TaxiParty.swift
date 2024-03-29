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
    let meetingTime: Int // (HHmm)
    let maxPersonNumber: Int
    let members: [String]
    let isClosed: Bool
}

// MARK: - Public Interface
extension TaxiParty {

    func isNotEmpty() -> Bool {
        members.count != 0
    }

    func isParticipating(id: String) -> Bool {
        members.contains(id)
    }

    var departure: String {
        Place.of(departureCode).rawValue
    }

    var destination: String {
        Place.of(destinationCode).rawValue
    }

    var currentMemeberCount: Int {
        return members.count
    }

    var readableMeetingTime: String {
        Date.convertToStringTime(from: meetingTime)
    }

    func isFull() -> Bool {
        members.count == maxPersonNumber
    }
}

extension TaxiParty: CustomStringConvertible {
    var description: String {
        "출발 날짜: \(meetingDate) 출발 시간: \(meetingTime) 출발지: \(Place.of(departureCode).rawValue) 도착지: \(Place.of(destinationCode).rawValue)"
    }
}

extension TaxiParty: Equatable {
    static func == (lhs: TaxiParty, rhs: TaxiParty) -> Bool {
        lhs.id == rhs.id && lhs.members == rhs.members
    }
}
