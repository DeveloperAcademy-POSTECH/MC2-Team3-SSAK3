//
//  TaxiPartyState.swift
//  Taxi
//
//  Created by JongHo Park on 2022/08/07.
//

// Taxi Party List 의 5가지 상태를 나타내는 enumeration
enum TaxiPartyState {
    case notRequested
    case loaded([(Int, [TaxiParty])])
    case error(error: Error)
    case empty
}

extension TaxiPartyState {
    var parties: [(Int, [TaxiParty])]? {
        switch self {
        case .loaded(let parties):
            return parties
        default:
            return nil
        }
    }

    var error: Error? {
        switch self {
        case .error(error: let error):
            return error
        default:
            return nil
        }
    }
}
