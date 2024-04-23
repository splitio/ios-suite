//
//  SplitSuiteBuilder.swift
//  iOSSplitSuite
//
//  Created by Javier Avrudsky on 06/12/2023.
//

import Foundation
import Split

public protocol SharedSplitSuiteBuilder {
    func config(_ config: SplitSuiteConfig) -> SplitSuiteBuilder
    func apiKey(_ apiKey: String) -> SplitSuiteBuilder
    func matchingKey(_ matchingKey: String) -> SplitSuiteBuilder
    func bucketingKey(_ bucketingKey: String) -> SplitSuiteBuilder
    func key(_ key: Key) -> SplitSuiteBuilder
    func build() -> SplitSuite?
}

public class SplitSuiteBuilder: SharedSplitSuiteBuilder {
    private var suiteConfig: SplitSuiteConfig = SplitSuiteConfig()
    private var apiKey: String?
    private var key: Key?
    private var matchingKey: String?
    private var bucketingKey: String?

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

        let key = Key(matchingKey: matchingKey, bucketingKey: bucketingKey)
        let defaultTrafficType = suiteConfig.sdkConfig.trafficType ?? SuiteConstants.trafficTypeUser
        guard let sdkFactory = DefaultSplitFactoryBuilder()
            .setKey(key)
            .setApiKey(apiKey)
            .setConfig(suiteConfig.sdkConfig).build() else {
            Logger.e("Could not create Split Factory")
            return nil
        }
        let rumAgent:InternalRumAgent = SuiteRumAgent()
        do {
            try rumAgent.setup(apiKey: apiKey, config: suiteConfig.rumConfig)
            rumAgent.addIdentity(key: key.matchingKey, trafficType: defaultTrafficType)
        } catch {
            Logger.e(" Could not create Split RUM: \(error.localizedDescription)")
            return nil
        }
        return SplitSuite(key: key, trafficType: defaultTrafficType, rumAgent: rumAgent, sdkFactory: sdkFactory)
    }
}
