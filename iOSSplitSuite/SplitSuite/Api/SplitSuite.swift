//
//  SplitSuite.swift
//  iOSSplitSuite
//
//  Created by Javier Avrudsky on 14/11/2023.
//

import Foundation
import Split
import SplitRumAgent

public class SplitSuite: SharedSplitSuite {

    private var sdkFactory: SplitFactory
    private var rumAgent: InternalRumAgent
    private let defaultTrafficType: String
    private let defaultKey: String
    private var clients = SynchronizedDictionary<Int, SuiteSdkClient>()

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
         rumAgent: InternalRumAgent,
         sdkFactory: SplitFactory) {

        self.defaultTrafficType = trafficType
        self.defaultKey = key.stringRepresentation()

        self.sdkFactory = sdkFactory
        self.rumAgent = rumAgent
    }

    public static func builder() -> SharedSplitSuiteBuilder {
        return SplitSuiteBuilder()
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

    public func removeProperties() {
        rumAgent.removeProperties()
    }
}

// MARK: track
extension SplitSuite {

    public func track(eventType: String, value: Double?, properties: [String : Any]?) -> Bool {
        // Track with agent to allow not having key and tt???
        return rumAgent.track(eventType: eventType,
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

    func registerClient(key: String, trafficType: String, client: SuiteSdkClient) {
        let hashKey = SplitIdentity.hashValue(key: key, trafficType: trafficType)
        clients.setValue(client, forKey: hashKey)
        rumAgent.addIdentity(key: key, trafficType: trafficType)
    }

    func notifyDestroy(key: String, trafficType: String, completion: DestroyCompletionHandler?) {
        let hashValue = SplitIdentity.hashValue(key: key, trafficType: trafficType)
        let client = clients.value(forKey: hashValue)
        clients.removeValue(forKey: hashValue)
        rumAgent.removeIdentity(key: key, trafficType: trafficType)
        if (clients.all.values.filter { $0.key == key }.count) == 0 {
            client?.realDestroy(completion: completion)
        }

    }

    private func getClient(key: Key, trafficType: String) -> SplitClient {
        let userKey = key.stringRepresentation()
        let hashKey = SplitIdentity.hashValue(key: userKey, trafficType: trafficType)
        if let client = clients.value(forKey: hashKey) {
            return client
        }
        let client = SplitSuiteSdkClient(client: sdkFactory.client(key: key),
                                         key: userKey,
                                         trafficType: trafficType,
                                         suiteCoordinator: self)
        registerClient(key: userKey, trafficType: trafficType, client: client)
        return client
    }
}
