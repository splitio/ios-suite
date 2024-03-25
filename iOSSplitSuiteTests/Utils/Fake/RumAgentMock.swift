//
//  RumAgentMock.swift
//  ests
//
//  Created by Javier Avrudsky on 29/01/2024.
//

@testable import iOSSplitSuite
import SplitRumAgent

struct IdHelper {
    static func generate() -> String {
        return UUID().uuidString
    }
}

struct Event {
    var storageId: String?
    let sessionId: String
    let eventTypeId: String
    let timestamp: Int64 = Date.nowMillis()
    var trafficType: String?
    var userKey: String?
    var trafficTypeName: String = "account"
    var value: Double?
    var properties: [String: Any]?
}

class RumAgentMock: InternalRumAgent {

    var anonymousId: String = IdHelper.generate()
    var sessionId: String = IdHelper.generate()

    var identities = [SplitIdentity]()
    var trackedEvents = [Event]()
    var properties = [String : Any]()

    // Variables to track if functions are called and their passed arguments
    var setupCalled = false
    var setupApiKey: String?
    var setupConfig: SplitRumConfig?
    var startCalled = false
    var stopCalled = false

    init() {
    }

    func setup(apiKey: String, config: SplitRumConfig) {
    }

    func start() {
        startCalled = true
    }

    func stop() {
        stopCalled = true
    }

    func addIdentity(key: String, trafficType: String) {
        identities.append(SplitIdentity(key: key, trafficType: trafficType))
    }

    func add(identities: [SplitIdentity]) {
        self.identities.append(contentsOf: identities)
    }

    func removeIdentity(key: String, trafficType: String) {
        identities.removeAll(where: { $0.key == key && $0.trafficType == trafficType })
    }

    func clearIdentities() {
        // Deprecated
        removeIdentities()
    }

    func removeIdentities() {
        identities.removeAll()
    }

    func track(eventType: String, userKey: String, trafficType: String, value: Double?, properties: [String : Any]?) -> Bool {
        var event = Event(sessionId: sessionId, eventTypeId: trafficType, trafficTypeName: trafficType)
        event.userKey = userKey
        event.value = value
        event.properties = properties
        trackedEvents.append(event)
        return true
    }

    func track(eventType: String, value: Double?, properties: [String : Any]?) -> Bool {
        var event = Event(sessionId: sessionId, eventTypeId: eventType)
        event.value = value
        event.properties = properties
        trackedEvents.append(event)
        return true
    }

    func track(error: SplitErrorEvent) -> Bool {
        var event = Event(sessionId: sessionId, eventTypeId: "error")
        event.properties = properties
        trackedEvents.append(event)
        return true
    }

    func setProperty(name: String, value: Any) {
        properties[name] = value
    }

    func set(properties: [String : Any]) {
        self.properties.merge(properties, uniquingKeysWith: { (_, new) in new })
    }

    func getValue(for property: String) -> Any? {
        return properties[property]
    }

    func remove(property: String) {
        properties.removeValue(forKey: property)
    }

    func removeProperties() {
        properties.removeAll()
    }

    func trackTimeFromStart(marker: String) {
        trackedEvents.append(Event(sessionId: sessionId, eventTypeId: marker))
    }
}
