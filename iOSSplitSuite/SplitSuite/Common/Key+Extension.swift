//
//  Key+Extension.swift
//  iOSSplitSuite
//
//  Created by Javier Avrudsky on 06/12/2023.
//

import Foundation
import Split

extension Key {
    public func stringRepresentation() -> String {
        return "\(matchingKey)\(bucketingKey ?? "")"
    }
}
