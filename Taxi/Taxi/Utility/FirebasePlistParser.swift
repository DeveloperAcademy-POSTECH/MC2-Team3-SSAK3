//
//  FirebasePlistParser.swift
//  Taxi
//
//  Created by JongHo Park on 2022/06/01.
//

import Foundation

struct FirebasePlistParser {
    private let dictionary: NSDictionary

    init() {
        let url = Bundle.main.url(forResource: "Firebase", withExtension: "plist")
        dictionary = NSDictionary(contentsOf: url!)!
    }

    func authDomain() -> String {
        return dictionary["AuthDomain"] as! String
    }
}
