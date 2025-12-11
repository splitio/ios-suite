//
//  Version.swift
//  iOSSplitSuite
//
//  Created by Javier Avrudsky on 25/03/2024.
//

import Foundation

struct Version {
    private static let kSdkPlatform: String = "ios-suite"

    private static let kVersion = "2.4.0"

    static var semantic: String {
        return kVersion
    }

    static var sdk: String {
        return "\(kSdkPlatform)-\(Version.semantic)"
    }
}
