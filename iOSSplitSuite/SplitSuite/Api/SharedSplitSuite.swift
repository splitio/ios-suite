//
//  SharedSplitSuite.swift
//  iOSSplitSuite
//
//  Created by Javier Avrudsky on 14/11/2023.
//

import Foundation
import SplitSdk

public protocol SplitRumAgent {

    // Identities
    var identities: [SplitIdentity] { get }
    func addIdentity(key: String, trafficType: String)
    func add(identities: [SplitIdentity])
    func removeIdentity(key: String, trafficType: String)
    func removeIdentities()

    // Properties
    var properties: [String: String] { get }
    func setProperty(name: String, value: String)
    func set(properties: [String: String])
    func getValue(for property: String) -> String?
    func remove(property: String)

    // Track
    func track(eventType: String,
               userKey: String,
               trafficType: String,
               value: Double?,
               properties: [String: Any]?) -> Bool

    func track(eventType: String,
               value: Double?,
               properties: [String: Any]?) -> Bool

    func track(error: SplitErrorEvent) -> Bool

    func trackTimeFromStart(marker: String)

}

protocol SplitSuiteCoordinator: AnyObject {
//    func getClient(key: Key, trafficType: String) -> SplitClient
    func registerClient(key: String, trafficType: String, client: SplitClient)
    func notifyDestroy(key: String, trafficType: String)
}

public protocol SharedSplitSuite: SplitFactory, SplitRumAgent {
    func client(key: Key, trafficType: String) -> SplitClient
}

