//
//  RumAgentMock.swift
//  iOSSplitSuiteTests
//
//  Created by Javier Avrudsky on 29/01/2024.
//

@testable import iOSSplitSuite

class RumAgentMock: RumAgent {
    var session: SessionHandler
    var notificationHelper: NotificationHelper
    var storageFacade: StorageFacade?
    var eventsRecorder: EventsRecorder?

    // Variables to track if functions are called and their passed arguments
    var setupCalled = false
    var setupApiKey: String?
    var setupConfig: SplitRumConfig?
    var setupTestComponentProvider: ComponentProvider?

    var startCalled = false
    var stopCalled = false

    init() {
        // Initialize the required properties with dummy values or mocks
        session = MockSessionHandler()
        notificationHelper = MockNotificationHelper()
        // Similarly initialize storageFacade and eventsRecorder if needed
    }

    func setup(apiKey: String?, config: SplitRumConfig?, testComponentProvider: ComponentProvider?) throws {
        setupCalled = true
        setupApiKey = apiKey
        setupConfig = config
        setupTestComponentProvider = testComponentProvider
        // You might want to throw an error in certain test cases
    }

    func start() {
        startCalled = true
    }

    func stop() {
        stopCalled = true
    }
}

// Mock implementations of the required dependencies
class MockSessionHandler: SessionHandler {
    // Implement the required methods and properties
}

class MockNotificationHelper: NotificationHelper {
    // Implement the required methods and properties
}

// Similarly create mocks for StorageFacade and EventsRecorder if necessary
