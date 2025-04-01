//
//  SplitSuiteClient.swift
//  iOSSplitSuite
//
//  Created by Javier Avrudsky on 21/11/2023.
//
import Foundation
import Split

protocol SuiteSdkClient: SplitClient {
    var key: String { get }
    func realDestroy(completion: DestroyCompletionHandler?)
}

class SplitSuiteSdkClient: SuiteSdkClient {

    private let client: SplitClient
    private let trafficType: String
    let key: String
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
        return client.getTreatment(split, attributes: attributes)
    }

    public func getTreatment(_ split: String) -> String {
        return client.getTreatment(split)
    }

    public func getTreatments(splits: [String], attributes: [String : Any]?) -> [String : String] {
        return client.getTreatments(splits: splits, attributes: attributes)
    }

    public func getTreatmentWithConfig(_ split: String) -> SplitResult {
        return client.getTreatmentWithConfig(split)
    }

    public func getTreatmentWithConfig(_ split: String, attributes: [String : Any]?) -> SplitResult {
        return client.getTreatmentWithConfig(split, attributes: attributes)
    }

    public func getTreatmentsWithConfig(splits: [String], attributes: [String : Any]?) -> [String : SplitResult] {
        return client.getTreatmentsWithConfig(splits: splits, attributes: attributes)
    }

    func getTreatment(_ split: String, attributes: [String : Any]?, evaluationOptions: Split.EvaluationOptions?) -> String {
        return client.getTreatment(split, attributes: attributes, evaluationOptions: evaluationOptions)
    }

    func getTreatments(splits: [String], attributes: [String : Any]?, evaluationOptions: Split.EvaluationOptions?) -> [String : String] {
        return client.getTreatments(splits: splits, attributes: attributes, evaluationOptions: evaluationOptions)
    }

    func getTreatmentWithConfig(_ split: String, attributes: [String : Any]?, evaluationOptions: Split.EvaluationOptions?) -> Split.SplitResult {
        return client.getTreatmentWithConfig(split, attributes: attributes, evaluationOptions: evaluationOptions)
    }

    func getTreatmentsWithConfig(splits: [String], attributes: [String : Any]?, evaluationOptions: Split.EvaluationOptions?) -> [String : Split.SplitResult] {
        return client.getTreatmentsWithConfig(splits: splits, attributes: attributes, evaluationOptions: evaluationOptions)
    }

    func getTreatmentsByFlagSet(_ flagSet: String, attributes: [String : Any]?, evaluationOptions: Split.EvaluationOptions?) -> [String : String] {
        return client.getTreatmentsByFlagSet(flagSet, attributes: attributes, evaluationOptions: evaluationOptions)
    }

    func getTreatmentsByFlagSets(_ flagSets: [String], attributes: [String : Any]?, evaluationOptions: Split.EvaluationOptions?) -> [String : String] {
        return client.getTreatmentsByFlagSets(flagSets, attributes: attributes, evaluationOptions: evaluationOptions)
    }

    func getTreatmentsWithConfigByFlagSet(_ flagSet: String, attributes: [String : Any]?, evaluationOptions: Split.EvaluationOptions?) -> [String : Split.SplitResult] {
        return client.getTreatmentsWithConfigByFlagSet(flagSet, attributes: attributes, evaluationOptions: evaluationOptions)
    }

    func getTreatmentsWithConfigByFlagSets(_ flagSets: [String], attributes: [String : Any]?, evaluationOptions: Split.EvaluationOptions?) -> [String : Split.SplitResult] {
        return client.getTreatmentsWithConfigByFlagSets(flagSets, attributes: attributes, evaluationOptions: evaluationOptions)
    }

    public func on(event: SplitEvent, execute action: @escaping SplitAction) {
        client.on(event: event, execute: action)
    }

    func on(event: Split.SplitEvent, runInBackground: Bool, execute action: @escaping Split.SplitAction) {
        client.on(event: event, runInBackground: runInBackground, execute: action)
    }

    func on(event: Split.SplitEvent, queue: DispatchQueue, execute action: @escaping Split.SplitAction) {
        client.on(event: event, queue: queue, execute: action)
    }

    public func track(trafficType: String, eventType: String) -> Bool {
        return client.track(trafficType: trafficType, eventType: eventType)
    }

    public func track(trafficType: String, eventType: String, value: Double) -> Bool {
        return client.track(trafficType: trafficType, eventType: eventType, value: value)
    }

    public func track(eventType: String) -> Bool {
        return client.track(eventType: eventType)
    }

    public func track(eventType: String, value: Double) -> Bool {
        return client.track(eventType: eventType, value: value)
    }

    public func setAttribute(name: String, value: Any) -> Bool {
        return client.setAttribute(name: name, value: value)
    }

    public func getAttribute(name: String) -> Any? {
        return client.getAttribute(name: name)
    }

    public func setAttributes(_ values: [String : Any]) -> Bool {
        return client.setAttributes(values)
    }

    public func getAttributes() -> [String : Any]? {
        return client.getAttributes()
    }

    public func removeAttribute(name: String) -> Bool {
        return client.removeAttribute(name: name)
    }

    public func clearAttributes() -> Bool {
        return client.clearAttributes()
    }

    public func flush() {
        client.flush()
    }

    public func destroy() {
        notifyDestroy(completion: nil)
    }

    public func destroy(completion: (() -> Void)?) {
        notifyDestroy(completion: completion)
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

    func realDestroy(completion: DestroyCompletionHandler?) {
        client.destroy(completion: completion)
    }

    private func notifyDestroy(completion: DestroyCompletionHandler?) {
        if let suiteCoordinator = self.suiteCoordinator {
            suiteCoordinator.notifyDestroy(key: key, trafficType: trafficType, completion: completion)
        }
    }
}
