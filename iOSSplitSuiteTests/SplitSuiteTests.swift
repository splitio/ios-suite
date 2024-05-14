//
//  SplitSuiteTests.swift
//  iOSSplitSuiteTests
//
//  Created by Javier Avrudsky on 29/01/2024.
//

import Foundation


import XCTest
@testable import iOSSplitSuite
import Split

class SplitSuiteTests: XCTestCase {

    var splitClient: SplitClient!
    var key: Key = Key(matchingKey: "key1")
    var trafficType: String = "tt1"
    var rumAgent: RumAgentMock!
    var sdkFactory: SplitFactoryMock!
    var suite: SplitSuite!

    override func setUp() {
        rumAgent = RumAgentMock()
        sdkFactory = SplitFactoryMock()

        suite = DefaultSplitSuite(key: key, trafficType: trafficType,
                           rumAgent: rumAgent, sdkFactory: sdkFactory)
    }

    func testIdentitiesRegistration() {
        let _ = suite.client
        let _ = suite.client(key: Key(matchingKey: "key1"), trafficType: "tt2")
        let _ = suite.client(matchingKey: "key2")
        let _ = suite.client(key: Key(matchingKey: "key3", bucketingKey: nil))
        let _ = suite.client(matchingKey: "key4", bucketingKey: "bucket4")

        XCTAssertNotNil(rumAgent.identities.filter { $0.key == "key1" && $0.trafficType == "tt1"})
        XCTAssertNotNil(rumAgent.identities.filter { $0.key == "key1" && $0.trafficType == "tt2"})
        XCTAssertNotNil(rumAgent.identities.filter { $0.key == "key2" && $0.trafficType == "tt1"})
        XCTAssertNotNil(rumAgent.identities.filter { $0.key == "key3" && $0.trafficType == "tt1"})
        XCTAssertNotNil(rumAgent.identities.filter { $0.key == "key4bucket4" && $0.trafficType == "tt1"})
    }

    func testRumTrack() {

        _ = suite.track(error: SplitErrorEvent(message: "Something fail", isFatal: true))
        _ = suite.track(eventType: "evt1", value: 1, properties: ["prop": 1])
        _ = suite.trackTimeFromStart(marker: "marker1")

        let _ = rumAgent.trackedEvents.filter { $0.eventTypeId == "error"}[0]
        let _ = rumAgent.trackedEvents.filter { $0.eventTypeId == "evt1"}[0]
        let _ = rumAgent.trackedEvents.filter { $0.eventTypeId == "marker1"}[0]
    }

    func testProperties() {
        suite.set(properties: ["p1": 1, "p2": "v1", "p3": 2.0])
        suite.setProperty(name: "p4", value: true)

        let prop1 = suite.properties
        let val2 = suite.getValue(for: "p2") as? String ?? ""

        suite.remove(property: "p1")

        let prop2 = suite.properties

        suite.removeProperties()

        let prop3 = suite.properties

        XCTAssertEqual(1, prop1["p1"] as? Int)
        XCTAssertEqual("v1", prop1["p2"] as? String)
        XCTAssertEqual(2.0, prop1["p3"] as? Double)
        XCTAssertEqual("v1", val2)

        XCTAssertEqual(3, prop2.count)
        XCTAssertNil(prop2["p1"])

        XCTAssertEqual(0, prop3.count)
    }

    func testUserConsent() {
        rumAgent.userConsentValue = false
        rumAgent.userConsentCalled = false
        sdkFactory.userConsentCalled = false
        sdkFactory.userConsentValue = false

        suite.setUserConsent(enabled: true)
        
        let rumV1 = rumAgent.userConsentValue
        let factV1 = sdkFactory.userConsentValue

        suite.setUserConsent(enabled: false)

        let rumV2 = rumAgent.userConsentValue
        let factV2 = sdkFactory.userConsentValue

        XCTAssertTrue(rumAgent.userConsentCalled)
        XCTAssertTrue(sdkFactory.userConsentCalled)

        XCTAssertTrue(rumV1)
        XCTAssertTrue(factV1)

        XCTAssertFalse(rumV2)
        XCTAssertFalse(factV2)

    }
}
