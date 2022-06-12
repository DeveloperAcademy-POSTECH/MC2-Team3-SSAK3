//
//  TaxiPartyMockData.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/11.
//

import Foundation

#if DEBUG
struct TaxiPartyMockData {
    static var mockData: [TaxiParty] {
        return [
        TaxiParty(id: "1", departureCode: 0, destinationCode: 1, meetingDate: 20220621, meetingTime: 1420, maxPersonNumber: 4, members: ["아보", "제리", "RaymondMorning", "Woody"], isClosed: false),
        TaxiParty(id: "2", departureCode: 0, destinationCode: 1, meetingDate: 20220610, meetingTime: 1331, maxPersonNumber: 3, members: ["아보", "레이몬드", "요셉"], isClosed: false),
        TaxiParty(id: "3", departureCode: 1, destinationCode: 0, meetingDate: 20220608, meetingTime: 1831, maxPersonNumber: 4, members: ["호종", "종호", "효상", "상효"], isClosed: false),
        TaxiParty(id: "4", departureCode: 1, destinationCode: 0, meetingDate: 20220630, meetingTime: 1931, maxPersonNumber: 4, members: ["인서", "서인", "윤영", "영윤"], isClosed: false),
        TaxiParty(id: "5", departureCode: 0, destinationCode: 1, meetingDate: 20220709, meetingTime: 1431, maxPersonNumber: 3, members: ["채호", "호채", "승연"], isClosed: false),
        TaxiParty(id: "6", departureCode: 1, destinationCode: 0, meetingDate: 20220621, meetingTime: 1931, maxPersonNumber: 3, members: ["연승", "효상", "인서"], isClosed: false)
        ]

    }
}
#endif
