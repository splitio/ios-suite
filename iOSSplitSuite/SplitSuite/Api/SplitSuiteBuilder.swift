//
//  SplitSuiteBuilder.swift
//  iOSSplitSuite
//
//  Created by Javier Avrudsky on 06/12/2023.
//

import Foundation
import SplitSdk

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

        let defaultTrafficType = suiteConfig.sdkConfig.trafficType ?? SuiteConstants.trafficTypeUser

        let key = Key(matchingKey: matchingKey, bucketingKey: bucketingKey)

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
            rumAgent.addIdentity(key: key.matchingKey, trafficType: defaultTrafficType)
        } catch {
            Logger.e("\(validationTag): Could not create Split RUM: \(error.localizedDescription)")
            return nil
        }
        return SplitSuite(key: key, trafficType: defaultTrafficType, rumAgent: rumAgent, sdkFactory: sdkFactory)
    }
}
