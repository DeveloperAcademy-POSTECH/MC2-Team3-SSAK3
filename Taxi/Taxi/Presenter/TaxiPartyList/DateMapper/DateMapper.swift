//
//  DataMapper.swift
//  Taxi
//
//  Created by JongHo Park on 2022/08/07.
//

struct DateMapper {
    func mapping(_ taxiParties: [TaxiParty]) -> [(key: Int, value: [TaxiParty])] {
        return Dictionary(grouping: taxiParties) { taxiParty in
            taxiParty.meetingDate
        }.sorted { first, second in
            return first.key < second.key
        }
    }
}
