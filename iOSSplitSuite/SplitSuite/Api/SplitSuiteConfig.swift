//
//  SplitSuiteConfig.swift
//  iOSSplitSuite
//
//  Created by Javier Avrudsky on 22/11/2023.
//

import Foundation
import SplitRumAgent
import Split

public class SplitSuiteConfig {

    private (set) var prefix: String? = nil

    public init() {}

    public func prefix(_ prefix: String) -> SplitSuiteConfig {
        self.prefix = prefix
        return self
    }
}

extension SplitRumAgent.SplitLogLevel {
    static func fromSuiteLevel(_ level: SplitLogLevel) -> SplitRumAgent.SplitLogLevel {
        return SplitRumAgent.SplitLogLevel(rawValue: level.rawValue) ?? .none
    }
}

extension SplitLogLevel {
    func toRumLevel() -> SplitRumAgent.SplitLogLevel {
        return SplitRumAgent.SplitLogLevel(rawValue: self.rawValue) ?? .none
    }
}
