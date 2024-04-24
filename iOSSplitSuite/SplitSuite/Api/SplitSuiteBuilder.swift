//
//  SplitSuiteBuilder.swift
//  iOSSplitSuite
//
//  Created by Javier Avrudsky on 06/12/2023.
//

import Foundation
import Split

public protocol SharedSplitSuiteBuilder {
//    func config(_ config: SplitSuiteConfig) -> SplitSuiteBuilder
//    func config(_ config: SplitClientConfig) -> SplitSuiteBuilder
//    func apiKey(_ apiKey: String) -> SplitSuiteBuilder
//    func matchingKey(_ matchingKey: String) -> SplitSuiteBuilder
//    func bucketingKey(_ bucketingKey: String) -> SplitSuiteBuilder
//    func key(_ key: Key) -> SplitSuiteBuilder
//    func build() -> SharedSplitSuite?

    ///
    /// Sets the Suite API Key
    /// returns: the current instance of SplitSuiteBuilder implementation
    ///
    @discardableResult
    func setApiKey(_ apiKey: String) -> SplitSuiteBuilder

    ///
    /// Sets the Matching Key to use. This method is specially usefull when creating
    /// a Key without Bucketing Key. If no Matching Key or Key is set the build method
    /// will fail.
    /// - parameter matchingKey: A string representing matching key
    /// - returns: the current instance of SplitSuiteBuilder implementation
    ///
    @discardableResult
    func setMatchingKey(_ matchingKey: String) -> SplitSuiteBuilder

    ///
    /// Sets the Bucketing Key to use. This method could be used in conjunction with setMatchingKey
    /// to avoid creating explicitly a Key instance
    /// - parameter bucketingKey: A string representing bucketing key
    /// - returns: the current instance of SplitSuiteBuilder implementation
    ///
    @discardableResult
    func setBucketingKey(_ bucketingKey: String) -> SplitSuiteBuilder

    ///
    /// Sets the Key to use. This method could be used instead of setMatchingKey
    /// and setBucketing
    /// - parameter key: An instances of Key class
    /// - returns: the current instance of SplitSuiteBuilder implementation
    ///
    @discardableResult
    func setKey(_ key: Key) -> SplitSuiteBuilder

    ///
    /// Sets the Split configuration to use. If this method is avoided
    /// default configuration values will be used
    /// - parameter config: An instances of SplitConfig class
    /// - returns: the current instance of SplitSuiteBuilder implementation
    ///
    @discardableResult
    func setConfig(_ config: SplitClientConfig) -> SplitSuiteBuilder

    ///
    /// Sets the Split configuration to use. If this method is avoided
    /// default configuration values will be used
    /// - parameter config: An instances of SplitConfig class
    /// - returns: the current instance of SplitSuiteBuilder implementation
    ///
    @discardableResult
    func setConfig(_ config: SplitSuiteConfig) -> SplitSuiteBuilder

    ///
    /// Builds the SplitFactory implementation instance based on set values
    /// - returns: An instance of SharedSplitSuite protocol implementation
    func build() -> SharedSplitSuite?
}

public class SplitSuiteBuilder: SharedSplitSuiteBuilder {

    private var suiteConfig: SplitSuiteConfig?
    private var sdkConfig: SplitClientConfig?
    private var apiKey: String?
    private var key: Key?
    private var matchingKey: String?
    private var bucketingKey: String?

    // Setters / builder
    @discardableResult
    public func setConfig(_ config: SplitSuiteConfig) -> SplitSuiteBuilder {
        self.suiteConfig = config
        return self
    }

    @discardableResult
    public func setConfig(_ config: SplitClientConfig) -> SplitSuiteBuilder {
        self.sdkConfig = config
        return self
    }

    @discardableResult
    public func setApiKey(_ apiKey: String) -> SplitSuiteBuilder {
        self.apiKey = apiKey
        return self
    }

    @discardableResult
    public func setMatchingKey(_ matchingKey: String) -> SplitSuiteBuilder {
        self.matchingKey = matchingKey
        return self
    }

    @discardableResult
    public func setBucketingKey(_ bucketingKey: String) -> SplitSuiteBuilder {
        self.bucketingKey = bucketingKey
        return self
    }

    @discardableResult
    public func setKey(_ key: Key) -> SplitSuiteBuilder {
        self.key = key
        return self
    }

    public func build() -> SharedSplitSuite? {
        guard let apiKey = self.apiKey else {
            Logger.e("API Key cannot be null")
            return nil
        }

        matchingKey  = matchingKey ?? key?.matchingKey
        bucketingKey  = bucketingKey ?? key?.bucketingKey

        guard let matchingKey = matchingKey else {
            Logger.e("Matching Key cannot be null")
            return nil
        }

        let suiteConfig = suiteConfig ?? SplitSuiteConfig()
        let sdkConfig = sdkConfig ?? SplitClientConfig()

        let key = Key(matchingKey: matchingKey, bucketingKey: bucketingKey)
        let defaultTrafficType = sdkConfig.trafficType ?? SuiteConstants.trafficTypeUser
        guard let sdkFactory = DefaultSplitFactoryBuilder()
            .setKey(key)
            .setApiKey(apiKey)
            .setConfig(sdkConfig).build() else {
            Logger.e("Could not create Split Factory")
            return nil
        }

        let rumConfig = buildRumConfig(suiteConfig: suiteConfig, sdkConfig: sdkConfig)
        let rumAgent:InternalRumAgent = SuiteRumAgent()
        do {
            try rumAgent.setup(apiKey: apiKey, config: rumConfig)
            rumAgent.addIdentity(key: key.matchingKey, trafficType: defaultTrafficType)
        } catch {
            Logger.e(" Could not create Split RUM: \(error.localizedDescription)")
            return nil
        }
        return SplitSuite(key: key, trafficType: defaultTrafficType, rumAgent: rumAgent, sdkFactory: sdkFactory)
    }

    private func buildRumConfig(suiteConfig: SplitSuiteConfig, sdkConfig: SplitClientConfig) -> SplitRumConfig {

        var rumConfig = SplitRumConfig()
            .logLevel(sdkConfig.logLevel.toRumLevel())
            .serviceEndpoints(sdkConfig.serviceEndpoints.asSplitServiceEndpoints())
            .eventsPushRate(sdkConfig.eventsPushRate)
        if let prefix = suiteConfig.prefix {
            rumConfig = rumConfig.prefix(prefix)
        }
        return rumConfig
    }
}
