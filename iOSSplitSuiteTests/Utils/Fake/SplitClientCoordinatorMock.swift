//
//  SplitClientCoordinatorMock.swift
//  iOSSplitSuiteTests
//
//  Created by Javier Avrudsky on 25/01/2024.
//

import Foundation
@testable import iOSSplitSuite
import Split

class SplitClientCoordinatorMock: SplitSuiteCoordinator {

    var clients: [String: SuiteSdkClient] = [:]

    var registerClientCalled = false
    var notifyDestroyedCalled = false
    var composedKey: String = ""

    func registerClient(key: String, trafficType: String, client: SuiteSdkClient) {
        clients[buildKey(key: key, trafficType: trafficType)] = client
        registerClientCalled = true
    }
    
    func notifyDestroy(key: String, trafficType: String, completion: DestroyCompletionHandler?) {
        let fullKey = buildKey(key: key, trafficType: trafficType)
        clients.removeValue(forKey: fullKey)
        notifyDestroyedCalled = true
    }

    private func buildKey(key: String, trafficType: String) -> String {
        composedKey = "\(key)_\(trafficType)"
        return composedKey
    }

}
