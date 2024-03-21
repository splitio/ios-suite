//
//  SplitSuiteTests.swift
//  iOSSplitSuiteTests
//
//  Created by Javier Avrudsky on 29/01/2024.
//

import Foundation


import XCTest
@testable import iOSSplitSuite
@testable import SplitSdk

class SplitSuiteTests: XCTestCase {

    var splitClient: SplitClient!
    var key: Key = Key(matchingKey: "key1")
    var trafficType: String = "tt1"
    var rumAgent: RumAgent!
    var sdkFactory: SplitFactory!
    var suite: SharedSplitSuite!

    override func setUp() {
        rumAgent = RumAgentMock()
        sdkFactory = SplitFactoryMock()
        suite = SplitSuite(key: key, trafficType: trafficType, 
                           rumAgent: rumAgent, sdkFactory: sdkFactory)
    }

    func testWhat() {

    }
}

