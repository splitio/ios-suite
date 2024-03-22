//
//  SplitSuiteConfig.swift
//  iOSSplitSuite
//
//  Created by Javier Avrudsky on 22/11/2023.
//

import Foundation
import Split
import SplitRumAgent

public class SplitSuiteConfig {
    private (set) var logLevel: SplitLogLevel = .none
    private (set) var prefix: String? = nil
    private (set) var serviceEndpoints: ServiceEndpoints? = nil
    private (set) var sdkConfig: SplitClientConfig = SplitClientConfig()
    private (set) var rumConfig: SplitRumConfig = SplitRumConfig()

    public init() {}

    // Setters / builder
    public func sdkConfig(_ sdkConfig: SplitClientConfig) -> SplitSuiteConfig {
        self.sdkConfig = sdkConfig
        return self
    }

    public func rumConfig(_ rumConfig: SplitRumConfig) -> SplitSuiteConfig {
        self.rumConfig = rumConfig
        return self
    }

    public func logLevel(_ logLevel: SplitLogLevel) -> SplitSuiteConfig {
        self.logLevel = logLevel
        applyLogLevel()
        return self
    }

    public func prefix(_ prefix: String) -> SplitSuiteConfig {
        self.prefix = prefix
        applyPrefix()
        return self
    }

    public func serviceEndpoints(_ serviceEndpoints: ServiceEndpoints) -> SplitSuiteConfig {
        self.serviceEndpoints = serviceEndpoints
        applyServiceEndpoints()
        return self
    }

    private func applyPrefix() {
        if let prefix = self.prefix {
            rumConfig = rumConfig.prefix(prefix)
            sdkConfig.prefix = prefix
        }
    }

    private func applyServiceEndpoints() {
        if let serviceEndpoints = self.serviceEndpoints {
            rumConfig = rumConfig.serviceEndpoints(serviceEndpoints.asSplitServiceEndpoints())
            sdkConfig.serviceEndpoints = serviceEndpoints
        }
    }

    private func applyLogLevel() {
        rumConfig = rumConfig.logLevel(SplitRumAgent.SplitLogLevel.fromSuiteLevel(self.logLevel))
        sdkConfig.logLevel = self.logLevel
    }
}

extension SplitRumAgent.SplitLogLevel {
    static func fromSuiteLevel(_ level: SplitLogLevel) -> SplitRumAgent.SplitLogLevel {
        return SplitRumAgent.SplitLogLevel(rawValue: level.rawValue) ?? .none
    }
}
