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
    var properties: [String: Any] { get }
    func setProperty(name: String, value: Any)
    func set(properties: [String: Any])
    func getValue(for property: String) -> Any?
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
    func registerClient(key: String, trafficType: String, client: SplitClient)
    func notifyDestroy(key: String, trafficType: String)
}

public protocol SharedSplitSuite: SplitFactory, SplitRumAgent {
    func client(key: Key, trafficType: String) -> SplitClient
}

