//
//  UserConsent+Extension.swift
//  iOSSplitSuite
//
//  Created by Javier Avrudsky on 15/05/2024.
//

import Foundation
import Split

extension UserConsent {
    func rumType() -> RumUserConsent {
        return RumUserConsent(rawValue: self.rawValue) ?? .unknown
    }
}
