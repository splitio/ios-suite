//
//  SplitSuiteClient.swift
//  iOSSplitSuite
//
//  Created by Javier Avrudsky on 21/11/2023.
//
import SplitSdk

class SplitSuiteSdkClient: SplitClient {
    private let client: SplitClient
    private let trafficType: String
    private let key: String
    weak private var suiteCoordinator: SplitSuiteCoordinator?

    init(client: SplitClient,
         key: String,
         trafficType: String,
         suiteCoordinator: SplitSuiteCoordinator) {
        self.client = client
        self.trafficType = trafficType
        self.key = key
        self.suiteCoordinator = suiteCoordinator
    }

    public func getTreatment(_ split: String, attributes: [String : Any]?) -> String {
        client.getTreatment(split, attributes: attributes)
    }

    public func getTreatment(_ split: String) -> String {
        client.getTreatment(split)
    }

    public func getTreatments(splits: [String], attributes: [String : Any]?) -> [String : String] {
        client.getTreatments(splits: splits, attributes: attributes)
    }

    public func getTreatmentWithConfig(_ split: String) -> SplitResult {
        client.getTreatmentWithConfig(split)
    }

    public func getTreatmentWithConfig(_ split: String, attributes: [String : Any]?) -> SplitResult {
        client.getTreatmentWithConfig(split, attributes: attributes)
    }

    public func getTreatmentsWithConfig(splits: [String], attributes: [String : Any]?) -> [String : SplitResult] {
        client.getTreatmentsWithConfig(splits: splits, attributes: attributes)
    }

    public func on(event: SplitEvent, execute action: @escaping SplitAction) {
        client.on(event: event, execute: action)
    }

    public func track(trafficType: String, eventType: String) -> Bool {
        client.track(trafficType: trafficType, eventType: eventType)
    }

    public func track(trafficType: String, eventType: String, value: Double) -> Bool {
        client.track(trafficType: trafficType, eventType: eventType, value: value)
    }

    public func track(eventType: String) -> Bool {
        client.track(eventType: eventType)
    }

    public func track(eventType: String, value: Double) -> Bool {
        client.track(eventType: trafficType, value: value)
    }

    public func setAttribute(name: String, value: Any) -> Bool {
        client.setAttribute(name: name, value: value)
    }

    public func getAttribute(name: String) -> Any? {
        client.getAttribute(name: name)
    }

    public func setAttributes(_ values: [String : Any]) -> Bool {
        client.setAttributes(values)
    }

    public func getAttributes() -> [String : Any]? {
        return client.getAttributes()
    }

    public func removeAttribute(name: String) -> Bool {
        client.removeAttribute(name: name)
    }

    public func clearAttributes() -> Bool {
        client.clearAttributes()
    }

    public func flush() {
        client.flush()
    }

    public func destroy() {
        client.destroy()
        notifyDestroy()
    }

    public func destroy(completion: (() -> Void)?) {
        client.destroy(completion: completion)
        notifyDestroy()
    }

    public func track(trafficType: String, eventType: String, properties: [String : Any]?) -> Bool {
        return client.track(trafficType: trafficType, eventType: eventType, properties: properties)
    }

    public func track(trafficType: String, eventType: String, value: Double, properties: [String : Any]?) -> Bool {
        return client.track(trafficType: trafficType, eventType: eventType, value: value, properties: properties)
    }

    public func track(eventType: String, properties: [String : Any]?) -> Bool {
        return client.track(eventType: eventType, properties: properties)
    }

    public func track(eventType: String, value: Double, properties: [String : Any]?) -> Bool {
        return client.track(eventType: eventType, value: value, properties: properties)
    }

    public func getTreatmentsByFlagSet(_ flagSet: String, attributes: [String : Any]?) -> [String : String] {
        return client.getTreatmentsByFlagSet(flagSet, attributes: attributes)
    }

    public func getTreatmentsByFlagSets(_ flagSets: [String], attributes: [String : Any]?) -> [String : String] {
        return client.getTreatmentsByFlagSets(flagSets, attributes: attributes)
    }

    public func getTreatmentsWithConfigByFlagSet(_ flagSet: String, attributes: [String : Any]?) -> [String : SplitResult] {
        return client.getTreatmentsWithConfigByFlagSet(flagSet, attributes: attributes)
    }

    public func getTreatmentsWithConfigByFlagSets(_ flagSets: [String], attributes: [String : Any]?) -> [String : SplitResult] {
        return client.getTreatmentsWithConfigByFlagSets(flagSets, attributes: attributes)
    }
}

extension SplitSuiteSdkClient {
    private func notifyDestroy() {
        if let suiteCoordinator = self.suiteCoordinator {
            suiteCoordinator.notifyDestroy(key: key, trafficType: trafficType)
        }
    }
}
