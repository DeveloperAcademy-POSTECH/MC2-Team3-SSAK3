//
//  TaxiPartyMockData.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/14.
//

import Foundation

#if DEBUG
struct TaxiPartyMockData {
    static var mockData: [TaxiParty] {
        return [
        TaxiParty(id: "1", departureCode: 0, destinationCode: 1, meetingDate: 20220621, meetingTime: 1420, maxPersonNumber: 4, members: ["1", "2", "3", "4"], isClosed: false),
        TaxiParty(id: "2", departureCode: 0, destinationCode: 1, meetingDate: 20220610, meetingTime: 1331, maxPersonNumber: 3, members: ["1", "2", "3"], isClosed: false),
        TaxiParty(id: "3", departureCode: 1, destinationCode: 0, meetingDate: 20220608, meetingTime: 1831, maxPersonNumber: 4, members: ["1", "2", "3", "4"], isClosed: false),
        TaxiParty(id: "4", departureCode: 1, destinationCode: 0, meetingDate: 20220630, meetingTime: 1931, maxPersonNumber: 4, members: ["1", "2", "3", "4"], isClosed: false),
        TaxiParty(id: "5", departureCode: 0, destinationCode: 1, meetingDate: 20220709, meetingTime: 1431, maxPersonNumber: 3, members: ["1", "2", "3"], isClosed: false),
        TaxiParty(id: "6", departureCode: 1, destinationCode: 0, meetingDate: 20220621, meetingTime: 1931, maxPersonNumber: 3, members: ["1", "2", "3"], isClosed: false)
        ]

    }
}
#endif
