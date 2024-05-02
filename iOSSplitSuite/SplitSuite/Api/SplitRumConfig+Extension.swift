//
//  SplitRumConfig+Extension.swift
//  iOSSplitSuite
//
//  Created by Javier Avrudsky on 23/01/2024.
//

import Foundation
import SplitRumAgent

extension ServiceEndpoints {
    func asSplitServiceEndpoints() -> SplitServiceEndpoints {
        return SplitServiceEndpoints().events(url: self.eventsEndpoint.absoluteString)
    }
}

extension SplitRumConfig {
    public func serviceEndpoints(_ serviceEndpoints: ServiceEndpoints) -> SplitRumConfig {
        return self.serviceEndpoints(serviceEndpoints.asSplitServiceEndpoints())
    }
}
