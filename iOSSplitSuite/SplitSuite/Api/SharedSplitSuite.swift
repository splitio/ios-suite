//
//  SharedSplitSuite.swift
//  iOSSplitSuite
//
//  Created by Javier Avrudsky on 14/11/2023.
//

import Foundation
import Split
import SplitRumAgent

public typealias SplitErrorEvent = SplitRumAgent.SplitErrorEvent
typealias DestroyCompletionHandler = ()->Void

public protocol RumAgent {

    // Properties
    var properties: [String: Any] { get }
    func setProperty(name: String, value: Any)
    func set(properties: [String: Any])
    func getValue(for property: String) -> Any?
    func remove(property: String)
    func removeProperties()

    func track(eventType: String,
               value: Double?,
               properties: [String: Any]?) -> Bool

    func track(error: SplitErrorEvent) -> Bool

    func trackTimeFromStart(marker: String)

}

protocol InternalRumAgent: RumAgent {
    var identities: [SplitIdentity] { get }
    func setup(apiKey: String, config: SplitRumAgent.SplitRumConfig) throws
    func addIdentity(key: String, trafficType: String)
    func add(identities: [SplitIdentity])
    func removeIdentity(key: String, trafficType: String)
    func removeIdentities()
}

protocol SplitSuiteCoordinator: AnyObject {
    func registerClient(key: String, trafficType: String, client: SuiteSdkClient)
    func notifyDestroy(key: String, trafficType: String, completion: DestroyCompletionHandler?)
}

public protocol SharedSplitSuite: SplitFactory, RumAgent {
    static func builder() -> SharedSplitSuiteBuilder
    func client(key: Key, trafficType: String) -> SplitClient
}
