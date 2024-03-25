//
//  Date+Extension.swift
//  iOSSplitSuiteTests
//
//  Created by Javier Avrudsky on 22/03/2024.
//

import Foundation

extension Date {
    func unixTimestamp() -> Int64 {
        return Int64(self.timeIntervalSince1970)
    }

    func unixTimestampInMiliseconds() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }

    static func now() -> Int64 {
        return Date().unixTimestamp()
    }

    static func nowMillis() -> Int64 {
        return Date().unixTimestampInMiliseconds()
    }
}
