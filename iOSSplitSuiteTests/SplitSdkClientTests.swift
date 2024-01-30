//
//  SplitSdkClient.swift
//  iOSSplitSuiteTests
//
//  Created by Javier Avrudsky on 25/01/2024.
//

import Foundation

import XCTest
@testable import iOSSplitSuite

class SplitSdkClientTests: XCTestCase {

    var suiteSdkClient: SplitSuiteSdkClient!
    var coordinator: SplitClientCoordinationMock!
    var client: SplitClientMock!

    let key = "key1"
    let trafficType = "tt1"


    override func setUp() {
        coordinator = SplitClientCoordinationMock()
        client = SplitClientMock()
        suiteSdkClient = SplitSuiteSdkClient(client: client,
                                             key: key,
                                             trafficType: trafficType,
                                             suiteCoordinator: coordinator)
    }

    func testGetTreatmentMethodsCalled() {

        let ff = "ff1"
        let ffs = [ff]
        let att = ["f1": 1]

        _ = suiteSdkClient.getTreatment(ff)
        _ = suiteSdkClient.getTreatment(ff, attributes: att)
        _ = suiteSdkClient.getTreatments(splits: ffs, attributes: att)
        _ = suiteSdkClient.getTreatmentWithConfig(ff)
        _ = suiteSdkClient.getTreatmentWithConfig(ff, attributes: att)
        _ = suiteSdkClient.getTreatmentsWithConfig(splits: ffs, attributes: att)

        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.getTreatment____.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.getTreatment___attributes__.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.getTreatments_splits_attributes__.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.getTreatmentWithConfig____.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.getTreatmentWithConfig___attributes__.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.getTreatmentsWithConfig_splits_attributes__.rawValue))
    }

    func testFlagsetsMethodsCalled() {
        let ff = "ff1"
        let ffs = [ff]
        let att = ["f1": 1]

        _ = suiteSdkClient.getTreatmentsByFlagSet(ff, attributes: att)
        _ = suiteSdkClient.getTreatmentsByFlagSets(ffs, attributes: att)
        _ = suiteSdkClient.getTreatmentsWithConfigByFlagSet(ff, attributes: att)
        _ = suiteSdkClient.getTreatmentsWithConfigByFlagSets(ffs, attributes: att)

        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.getTreatmentsByFlagSet___attributes__.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.getTreatmentsByFlagSets___attributes__.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.getTreatmentsWithConfigByFlagSet___attributes__.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.getTreatmentsWithConfigByFlagSets___attributes__.rawValue))
    }

    func testAttributesAndDestroyMethodsCalled() {

        let ff = "ff1"
        let att = ["f1": 1]
        let val = 1

        _ = suiteSdkClient.setAttributes(att)
        _ = suiteSdkClient.getAttributes()
        _ = suiteSdkClient.getAttribute(name: ff)
        _ = suiteSdkClient.setAttribute(name: ff, value: val)
        _ = suiteSdkClient.removeAttribute(name: ff)
        _ = suiteSdkClient.clearAttributes()

        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.setAttributes____.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.getAttributes__.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.getAttribute_name__.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.setAttribute_name_value__.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.removeAttribute_name__.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.clearAttributes__.rawValue))
    }

    func testFlushDestroyOnMethodsCalled() {

        suiteSdkClient.flush()
        suiteSdkClient.destroy()
        suiteSdkClient.destroy(completion: {})
        suiteSdkClient.on(event: .sdkReady) {}

        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.flush__.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.destroy__.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.destroy_completion__.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.on_event_event_execute__.rawValue))
    }

    func testDestroyNotify() {
        let notifyDestroyedCalledBefore = coordinator.notifyDestroyedCalled
        
        coordinator.registerClient(key: key, trafficType: trafficType, client: suiteSdkClient)
        let client = coordinator.clients[coordinator.composedKey]

        suiteSdkClient.destroy()

        let clientDestroyed = coordinator.clients[coordinator.composedKey]

        XCTAssertNotNil(client)
        XCTAssertNil(clientDestroyed)
        XCTAssertFalse(notifyDestroyedCalledBefore)
        XCTAssertTrue(coordinator.notifyDestroyedCalled)
    }

    func testTrackMethodsCalled() {
        let evt = "evt1"
        let tt = "tt1"
        let value: Double = 1.0
        let props = ["f1": 1]

        _ = suiteSdkClient.track(eventType: evt)
        _ = suiteSdkClient.track(trafficType: tt, eventType: evt)
        _ = suiteSdkClient.track(trafficType: tt, eventType: evt, value: value)
        _ = suiteSdkClient.track(eventType: evt, value: value)
        _ = suiteSdkClient.track(trafficType: tt, eventType: evt, properties: props)
        _ = suiteSdkClient.track(trafficType: tt, eventType: evt, value: value, properties: props)
        _ = suiteSdkClient.track(eventType: evt, properties: props)
        _ = suiteSdkClient.track(eventType: evt, value: value, properties: props)


        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.track_eventType__.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.track_trafficType_eventType__.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.track_trafficType_eventType_value__.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.track_eventType_value__.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.track_trafficType_eventType_properties__.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.track_trafficType_eventType_value_properties__.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.track_eventType_properties__.rawValue))
        XCTAssertTrue(client.wasMethodCalled(SplitClientMock.Method.track_eventType_value_properties__.rawValue))
    }
}

