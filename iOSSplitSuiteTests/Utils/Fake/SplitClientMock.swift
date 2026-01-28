// SplitClientMock.swift

import Foundation
@testable import Split

public class SplitClientMock: SplitClient {

    private let defaultTreatment = "defaultTreatment"

    // Enum to represent different method calls
    enum Method: String, CaseIterable {

        case getTreatment____ = "getTreatment(_:)"
        case getTreatment___attributes__ = "getTreatment(_:attributes:)"
        case getTreatments_splits_attributes__ = "getTreatments(splits:attributes:)"
        case getTreatmentWithConfig____ = "getTreatmentWithConfig(_:)"
        case getTreatmentWithConfig___attributes__ = "getTreatmentWithConfig(_:attributes:)"
        case getTreatmentsWithConfig_splits_attributes__ = "getTreatmentsWithConfig(splits:attributes:)"

        case getTreatmentsByFlagSet___attributes__ = "getTreatmentsByFlagSet(_:attributes:)"
        case getTreatmentsByFlagSets___attributes__ = "getTreatmentsByFlagSets(_:attributes:)"
        case getTreatmentsWithConfigByFlagSet___attributes__ = "getTreatmentsWithConfigByFlagSet(_:attributes:)"
        case getTreatmentsWithConfigByFlagSets___attributes__ = "getTreatmentsWithConfigByFlagSets(_:attributes:)"

        case track_eventType__ = "track(eventType:)"
        case track_trafficType_eventType__ = "track(trafficType:eventType:)"
        case track_trafficType_eventType_value__ = "track(trafficType:eventType:value:)"
        case track_eventType_value__ = "track(eventType:value:)"
        case track_trafficType_eventType_properties__ = "track(trafficType:eventType:properties:)"
        case track_trafficType_eventType_value_properties__ = "track(trafficType:eventType:value:properties:)"
        case track_eventType_properties__ = "track(eventType:properties:)"
        case track_eventType_value_properties__ = "track(eventType:value:properties:)"

        case setAttributes____ = "setAttributes(_:)"
        case getAttributes__ = "getAttributes()"
        case getAttribute_name__ = "getAttribute(name:)"
        case setAttribute_name_value__ = "setAttribute(name:value:)"
        case removeAttribute_name__ = "removeAttribute(name:)"
        case clearAttributes__ = "clearAttributes()"
        case flush__ = "flush()"
        case destroy__ = "destroy()"
        case destroy_completion__ = "destroy(completion:)"
        case on_event_event_execute__ = "on(event:execute:)"

        static func from(_ functionName: String) -> Method? {
            return Method.allCases.first(where: { "\($0)" == functionName })
        }
    }

    // Dictionary to record method calls
    var methodsCalled = Set<String>()

    private func recordCall(_ functionName: String) {
        print(functionName)
        methodsCalled.insert(functionName)
    }

    // MARK: Evaluation feature implementations
    public func getTreatment(_ split: String, attributes: [String: Any]?) -> String {
        recordCall(#function)
        return defaultTreatment
    }

    public func getTreatment(_ split: String) -> String {
        recordCall(#function)
        return defaultTreatment
    }

    public func getTreatments(splits: [String], attributes: [String: Any]?) -> [String: String] {
        recordCall(#function)
        return splits.reduce(into: [String: String]()) { $0[$1] = defaultTreatment }
    }

    public func getTreatmentWithConfig(_ split: String) -> SplitResult {
        recordCall(#function)
        return SplitResult(treatment: defaultTreatment, config: nil)
    }

    public func getTreatmentWithConfig(_ split: String, attributes: [String: Any]?) -> SplitResult {
        recordCall(#function)
        return SplitResult(treatment: defaultTreatment, config: nil)
    }

    public func getTreatmentsWithConfig(splits: [String], attributes: [String: Any]?) -> [String: SplitResult] {
        recordCall(#function)
        return splits.reduce(into: [String: SplitResult]()) { $0[$1] = SplitResult(treatment: defaultTreatment, config: nil) }
    }

    public func on(event: SplitEvent, execute action: @escaping SplitAction) {
        recordCall(#function)
        // Dummy implementation
    }

    public func on(event: SplitEvent, runInBackground: Bool, execute action: @escaping SplitAction) {
        recordCall(#function)
    }

    public func on(event: SplitEvent, queue: DispatchQueue, execute action: @escaping SplitAction) {
        recordCall(#function)
    }
    
    public func addEventListener(listener: SplitEventListener) {
        recordCall(#function)
    }

    public func track(trafficType: String, eventType: String, properties: [String : Any]?) -> Bool {
        recordCall(#function)
        return true
    }

    public func track(trafficType: String, eventType: String, value: Double, properties: [String : Any]?) -> Bool {
        recordCall(#function)
        return true
    }

    public func track(eventType: String, properties: [String : Any]?) -> Bool {
        recordCall(#function)
        return true
    }

    public func track(eventType: String, value: Double, properties: [String : Any]?) -> Bool {
        recordCall(#function)
        return true
    }

    // MARK: Track feature implementations
    public func track(trafficType: String, eventType: String) -> Bool {
        recordCall(#function)
        return true
    }

    public func track(trafficType: String, eventType: String, value: Double) -> Bool {
        recordCall(#function)
        return true
    }

    public func track(eventType: String) -> Bool {
        recordCall(#function)
        return true
    }

    public func track(eventType: String, value: Double) -> Bool {
        recordCall(#function)
        return true
    }

    public func getTreatmentsByFlagSet(_ flagSet: String, attributes: [String : Any]?) -> [String : String] {
        recordCall(#function)
        return [:]
    }

    public func getTreatmentsByFlagSets(_ flagSets: [String], attributes: [String : Any]?) -> [String : String] {
        recordCall(#function)
        return [:]
    }

    public func getTreatmentsWithConfigByFlagSet(_ flagSet: String, attributes: [String : Any]?) -> [String : SplitResult] {
        recordCall(#function)
        return [:]
    }

    public func getTreatmentsWithConfigByFlagSets(_ flagSets: [String], attributes: [String : Any]?) -> [String : SplitResult] {
        recordCall(#function)
        return [:]
    }

    public func getTreatment(_ split: String, attributes: [String : Any]?, evaluationOptions: EvaluationOptions?) -> String {
        recordCall(#function)
        return defaultTreatment
    }

    public func getTreatments(splits: [String], attributes: [String : Any]?, evaluationOptions: EvaluationOptions?) -> [String : String] {
        recordCall(#function)
        return splits.reduce(into: [String: String]()) { $0[$1] = defaultTreatment }
    }

    public func getTreatmentWithConfig(_ split: String, attributes: [String : Any]?, evaluationOptions: EvaluationOptions?) -> SplitResult {
        recordCall(#function)
        return SplitResult(treatment: defaultTreatment, config: nil)
    }

    public func getTreatmentsWithConfig(splits: [String], attributes: [String : Any]?, evaluationOptions: EvaluationOptions?) -> [String : SplitResult] {
        recordCall(#function)
        return splits.reduce(into: [String: SplitResult]()) { $0[$1] = SplitResult(treatment: defaultTreatment, config: nil) }
    }

    public func getTreatmentsByFlagSet(_ flagSet: String, attributes: [String : Any]?, evaluationOptions: EvaluationOptions?) -> [String : String] {
        recordCall(#function)
        return [:]
    }

    public func getTreatmentsByFlagSets(_ flagSets: [String], attributes: [String : Any]?, evaluationOptions: EvaluationOptions?) -> [String : String] {
        recordCall(#function)
        return [:]
    }

    public func getTreatmentsWithConfigByFlagSet(_ flagSet: String, attributes: [String : Any]?, evaluationOptions: EvaluationOptions?) -> [String : SplitResult] {
        recordCall(#function)
        return [:]
    }

    public func getTreatmentsWithConfigByFlagSets(_ flagSets: [String], attributes: [String : Any]?, evaluationOptions: EvaluationOptions?) -> [String : SplitResult] {
        recordCall(#function)
        return [:]
    }

    // MARK: Client lifecycle implementations
    public func flush() {
        recordCall(#function)
        // Dummy implementation
    }

    public func destroy() {
        recordCall(#function)
        // Dummy implementation
    }

    public func destroy(completion: (() -> Void)?) {
        recordCall(#function)
        completion?()
    }

    // MARK: Persistent attributes feature implementations
    public func setAttribute(name: String, value: Any) -> Bool {
        recordCall(#function)
        return true
    }

    public func getAttribute(name: String) -> Any? {
        recordCall(#function)
        return nil
    }

    public func setAttributes(_ values: [String: Any]) -> Bool {
        recordCall(#function)
        return true
    }

    public func getAttributes() -> [String: Any]? {
        recordCall(#function)
        return nil
    }

    public func removeAttribute(name: String) -> Bool {
        recordCall(#function)
        return true
    }

    public func clearAttributes() -> Bool {
        recordCall(#function)
        return true
    }

    // Utility method to check if a method was called
    func wasMethodCalled(_ method: String) -> Bool {
        return methodsCalled.contains(method)
    }
}

