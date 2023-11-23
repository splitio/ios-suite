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

    // TODO: Update Rum Agent public interface
    public var properties: [String : String] {
        return [:]
    }

    public var identities: [SplitIdentity] = []

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

// MARK: Identities
extension SplitSuite {
    public func addIdentity(key: String, trafficType: String) {
        rumAgent.addIdentity(key: key, trafficType: trafficType)
    }

    public func add(identities: [SplitIdentity]) {
        rumAgent.add(identities: identities)
    }

    public func removeIdentity(key: String, trafficType: String) {
        rumAgent.removeIdentity(key: key, trafficType: trafficType)
    }

    public func removeIdentities() {
        rumAgent.clearIdentities()
    }

    public func setProperty(name: String, value: String) {
        rumAgent.setProperty(name: name, value: value)
    }

    public func set(properties: [String : String]) {
        rumAgent.set(properties: properties)
    }

    public func getValue(for property: String) -> String? {
        return rumAgent.getValue(for: property)
    }

    public func remove(property: String) {
        rumAgent.remove(property: property)
    }

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


public protocol SharedSplitSuiteBuilder {

}

public class SplitSuiteBuilder: SharedSplitSuiteBuilder {
    private var suiteConfig: SplitSuiteConfig = SplitSuiteConfig()
    private var apiKey: String?
    private var key: Key?
    private var matchingKey: String?
    private var bucketingKey: String?
    private let keyValidator: KeyValidator
    private let apiKeyValidator: ApiKeyValidator
    private let validationLogger: ValidationMessageLogger

    public init() {
        keyValidator = MainKeyValidator()
        apiKeyValidator = MainApiKeyValidator()
        validationLogger = MainValidationMessageLogger()
    }

    // Setters / builder
    @discardableResult
    public func config(_ config: SplitSuiteConfig) -> SplitSuiteBuilder {
        self.suiteConfig = config
        return self
    }

    @discardableResult
    public func apiKey(_ apiKey: String) -> SplitSuiteBuilder {
        self.apiKey = apiKey
        return self
    }

    @discardableResult
    public func matchingKey(_ matchingKey: String) -> SplitSuiteBuilder {
        self.matchingKey = matchingKey
        return self
    }

    @discardableResult
    public func bucketingKey(_ bucketingKey: String) -> SplitSuiteBuilder {
        self.bucketingKey = bucketingKey
        return self
    }

    @discardableResult
    public func key(_ key: Key) -> SplitSuiteBuilder {
        self.key = key
        return self
    }

    public func build() -> SplitSuite? {
        let validationTag = "SplitSuiteBuilder.build"
        if let errorInfo = apiKeyValidator.validate(apiKey: apiKey) {
            validationLogger.log(errorInfo: errorInfo, tag: validationTag)
            return nil
        }

        let matchingKey = self.matchingKey ?? key?.matchingKey
        let bucketingKey = self.bucketingKey ?? key?.bucketingKey

        if let errorInfo = keyValidator.validate(matchingKey: matchingKey, bucketingKey: bucketingKey) {
            validationLogger.log(errorInfo: errorInfo, tag: validationTag)
            return nil
        }

        guard let apiKey = self.apiKey else {
            // Will never reach here
            return nil
        }

        guard let matchingKey = matchingKey else {
            // Will never reach here
            return nil
        }

        let key = Key(matchingKey: matchingKey, bucketingKey: bucketingKey)
        if let prefix = suiteConfig.prefix {
            // TODO: Add prefix to sdk
            // TODO: Use prefix in RUM agent
            _ = suiteConfig.rumConfig.prefix(prefix)
//            _ = suiteConfig.sdkConfig.prefix(prefix)
        }

        guard let sdkFactory = DefaultSplitFactoryBuilder()
            .setKey(key)
            .setApiKey(apiKey)
            .setConfig(suiteConfig.sdkConfig).build() else {
            Logger.e("\(validationTag): Could not create Split Factory")
            return nil
        }
        let rumAgent = MainRumAgent()
        do {
            try rumAgent.setup(apiKey: apiKey, config: suiteConfig.rumConfig)
        } catch {
            Logger.e("\(validationTag): Could not create Split RUM: \(error.localizedDescription)")
            return nil
        }
        return SplitSuite(key: key, trafficType: suiteConfig.sdkConfig.trafficType ?? SuiteConstants.trafficTypeUser, rumAgent: rumAgent, sdkFactory: sdkFactory)
    }
}
