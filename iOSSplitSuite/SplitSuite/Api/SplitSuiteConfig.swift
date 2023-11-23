//
//  SplitSuiteConfig.swift
//  iOSSplitSuite
//
//  Created by Javier Avrudsky on 22/11/2023.
//

import Foundation
import SplitSdk

public class SplitSuiteConfig {
    private (set) var prefix: String? = nil
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

    public func prefix(_ prefix: String) -> SplitSuiteConfig {
        self.prefix = prefix
        return self
    }
}
