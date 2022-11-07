//
//  ProcessInfoExtension.swift
//  Taxi
//
//  Created by JongHo Park on 2022/11/07.
//

import Foundation

extension ProcessInfo {
    var isRunningTests: Bool {
        environment["XCTestConfigurationFilePath"] != nil
    }
}
