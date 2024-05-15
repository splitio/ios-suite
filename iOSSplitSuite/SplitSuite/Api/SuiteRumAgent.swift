//
//  SuiteRumAgent.swift
//  iOSSplitSuite
//
//  Created by Javier Avrudsky on 19/03/2024.
//

import Foundation
import SplitRumAgent

class SuiteRumAgent: InternalRumAgent {

    func setUserConsent(enabled: Bool) {
        SplitRum.setUserConsent(enabled: enabled)
    }
    
    var identities: [SplitRumAgent.SplitIdentity] {
        return SplitRum.identities
    }

    func setup(apiKey: String, config: SplitRumAgent.SplitRumConfig) throws {
        try SplitRum.setup(apiKey: apiKey, config: config)
    }

    func addIdentity(key: String, trafficType: String) {
        SplitRum.addIdentity(key: key, trafficType: trafficType)
    }

    func add(identities: [SplitRumAgent.SplitIdentity]) {
        SplitRum.add(identities: identities)
    }

    func removeIdentity(key: String, trafficType: String) {
        SplitRum.removeIdentity(key: key, trafficType: trafficType)
    }

    func removeIdentities() {
        SplitRum.removeIdentities()
    }

    var properties: [String : Any] {
        return SplitRum.properties
    }

    func setProperty(name: String, value: Any) {
        SplitRum.setProperty(name: name, value: value)
    }
    
    func set(properties: [String : Any]) {
        SplitRum.set(properties: properties)
    }
    
    func getValue(for property: String) -> Any? {
        return SplitRum.getValue(for: property)
    }
    
    func remove(property: String) {
        SplitRum.remove(property: property)
    }
    
    func removeProperties() {
//        SplitRum.removeProperties()
    }
    
    func track(eventType: String, value: Double?, properties: [String : Any]?) -> Bool {
        SplitRum.track(eventType: eventType, value: value, properties: properties)
    }
    
    func track(error: SplitErrorEvent) -> Bool {
        SplitRum.track(error: error)
    }
    
    func trackTimeFromStart(marker: String) {
        SplitRum.trackTimeFromStart(marker: marker)
    }
}
