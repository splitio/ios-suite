//
//  SplitIdentity+Extension.swift
//  iOSSplitSuite
//
//  Created by Javier Avrudsky on 22/11/2023.
//

import Foundation
import SplitRumAgent

extension SplitIdentity: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(trafficType)
    }

    public static func == (lhs: SplitIdentity, rhs: SplitIdentity) -> Bool {
        return lhs.key == rhs.key && lhs.trafficType == rhs.trafficType
    }

    var hashIdentity: Int {
        return Self.hashValue(key: key, trafficType: trafficType)
    }

    static func hashValue(key: String, trafficType: String) -> Int {
        var hasher = Hasher()
        hasher.combine(key)
        hasher.combine(trafficType)
        return hasher.finalize()
    }
}
