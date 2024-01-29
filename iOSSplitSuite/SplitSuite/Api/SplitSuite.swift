//
//  SplitSuite.swift
//  iOSSplitSuite
//
//  Created by Javier Avrudsky on 14/11/2023.
//

import Foundation
import SplitSdk

public class SplitSuite: SharedSplitSuite {
    
    private var clients = SynchronizedDictionary<SplitIdentity, SplitClient>()
    private var sdkFactory: SplitFactory
    private var rumAgent: RumAgent
    private let defaultTrafficType: String
    private let defaultKey: String

    public var properties: [String : Any] {
        return rumAgent.properties
    }

    public var client: SplitClient {
        return sdkFactory.client
    }

    public var manager: SplitManager {
        return sdkFactory.manager
    }

    public var userConsent: UserConsent {
        return sdkFactory.userConsent
    }

    public var version: String {
        return sdkFactory.version
    }

    init(key: Key,
         trafficType: String,
         rumAgent: RumAgent,
         sdkFactory: SplitFactory) {

        self.defaultTrafficType = trafficType
        self.defaultKey = key.stringRepresentation()

        self.sdkFactory = sdkFactory
        self.rumAgent = rumAgent
    }
}

// MARK: SDK Factory
extension SplitSuite {

    public func setUserConsent(enabled: Bool) {
        sdkFactory.setUserConsent(enabled: enabled)
    }

    public func client(key: Key) -> SplitClient {
        return getClient(key: key, trafficType: defaultTrafficType)
    }

    public func client(matchingKey: String) -> SplitClient {
        return getClient(key: Key(matchingKey: matchingKey), trafficType: defaultTrafficType)
    }

    public func client(matchingKey: String, bucketingKey: String?) -> SplitClient {
        return getClient(key: Key(matchingKey: matchingKey, bucketingKey: bucketingKey), trafficType: defaultTrafficType)
    }

    public func client(key: Key, trafficType: String) -> SplitClient {
        return getClient(key: key, trafficType: trafficType)
    }
}

// MARK: properties
extension SplitSuite {

    public func setProperty(name: String, value: Any) {
        rumAgent.setProperty(name: name, value: value)
    }

    public func set(properties: [String : Any]) {
        rumAgent.set(properties: properties)
    }

    public func getValue(for property: String) -> Any? {
        return rumAgent.getValue(for: property)
    }

    public func remove(property: String) {
        rumAgent.remove(property: property)
    }
}

// MARK: track
extension SplitSuite {
    public func track(eventType: String, userKey: String, trafficType: String, value: Double?, properties: [String : Any]?) -> Bool {
        return rumAgent.track(eventType: eventType,
                              userKey: userKey,
                              trafficType: trafficType,
                              value: value,
                              properties: properties)
    }

    public func track(eventType: String, value: Double?, properties: [String : Any]?) -> Bool {
        // Track with agent to allow not having key and tt???
        return rumAgent.track(eventType: eventType,
                              userKey: defaultKey,
                              trafficType: defaultTrafficType,
                              value: value,
                              properties: properties)
    }

    public func track(error: SplitErrorEvent) -> Bool {
        return rumAgent.track(error: error)
    }

    public func trackTimeFromStart(marker: String) {
        rumAgent.trackTimeFromStart(marker: marker)
    }
}

extension SplitSuite: SplitSuiteCoordinator {

    func registerClient(key: String, trafficType: String, client: SplitClient) {
        clients.setValue(client, forKey: SplitIdentity(key: key, trafficType: trafficType))
        rumAgent.addIdentity(key: key, trafficType: trafficType)
    }

    func notifyDestroy(key: String, trafficType: String) {
        clients.removeValue(forKey: SplitIdentity(key: key, trafficType: trafficType))
        rumAgent.removeIdentity(key: key, trafficType: trafficType)
    }

    private func getClient(key: Key, trafficType: String) -> SplitSdk.SplitClient {
        let userKey = key.stringRepresentation()
        if let client = clients.value(forKey: SplitIdentity(key: userKey, trafficType: trafficType)) {
            return client
        }
        let client = SplitSuiteSdkClient(client: sdkFactory.client(matchingKey: userKey),
                                         key: userKey,
                                         trafficType: trafficType,
                                         suiteCoordinator: self)
        registerClient(key: userKey, trafficType: trafficType, client: client)
        return client
    }
}
