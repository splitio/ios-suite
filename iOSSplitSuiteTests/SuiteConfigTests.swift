//
//  iOSSplitSuiteTests.swift
//  iOSSplitSuiteTests
//
//  Created by Javier Avrudsky on 14/11/2023.
//

import XCTest
@testable import iOSSplitSuite

final class SuiteConfigTests: XCTestCase {

    static let baseEp = "http://192.168.217.84:8080/"
    static let sdkEp = "\(baseEp)/sdk"
    static let eveEp = "\(baseEp)/ev"
    static let authEp = "\(baseEp)/au"
    static let streamEp = "\(baseEp)/st"
    static let teleEp = "\(baseEp)/tl"

    let apiKey = "api_key"
    let key = Key(matchingKey: "m_key")

    func testConfigMerge() throws {
        let serviceEndpoints = ServiceEndpoints.builder()
            .set(sdkEndpoint: Self.sdkEp)
            .set(eventsEndpoint: Self.eveEp)
            .set(eventsEndpoint: Self.authEp)
            .set(eventsEndpoint: Self.streamEp)
            .set(eventsEndpoint: Self.teleEp)
            .build()

        let config = SplitSuiteConfig().serviceEndpoints(serviceEndpoints).logLevel(.info)



        XCTAssertEqual(config.prefix, config.rumConfig.prefix)
        XCTAssertEqual(config.prefix, config.sdkConfig.prefix)

        XCTAssertEqual(config.logLevel, config.rumConfig.logLevel)
        XCTAssertEqual(config.logLevel, config.sdkConfig.logLevel)

        XCTAssertEqual(config.serviceEndpoints?.eventsEndpoint.absoluteString, config.rumConfig.serviceEndpoints.events)
        XCTAssertEqual(config.serviceEndpoints?.eventsEndpoint.absoluteString, config.sdkConfig.serviceEndpoints.eventsEndpoint.absoluteString)

        XCTAssertEqual(config.serviceEndpoints?.sdkEndpoint.absoluteString, config.sdkConfig.serviceEndpoints.sdkEndpoint.absoluteString)
        XCTAssertEqual(config.serviceEndpoints?.authServiceEndpoint.absoluteString, config.sdkConfig.serviceEndpoints.authServiceEndpoint.absoluteString)
        XCTAssertEqual(config.serviceEndpoints?.streamingServiceEndpoint.absoluteString, config.sdkConfig.serviceEndpoints.streamingServiceEndpoint.absoluteString)
        XCTAssertEqual(config.serviceEndpoints?.telemetryServiceEndpoint.absoluteString, config.sdkConfig.serviceEndpoints.telemetryServiceEndpoint.absoluteString)
    }
}
