//
//  SuiteKey.swift
//  iOSSplitSuite
//
//  Created by Javier Avrudsky on 23/11/2023.
//

import Foundation

extension Key {
    func stringRepresentation() -> String {
        return "\(matchingKey)\(bucketingKey ?? "")"
    }
}
