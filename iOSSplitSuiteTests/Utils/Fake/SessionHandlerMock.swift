//
//  SessionHandlerMock.swift
//  iOSSplitSuiteTests
//
//  Created by Javier Avrudsky on 29/01/2024.
//

@testable import iOSSplitSuite

class SessionHandlerMock: SessionHandler {
    var currentId: String = "mockId"
    var identities: [SplitIdentity] = []
    var startTime: Int64 = 0
    var isFirst: Bool = true
    var storage: PersistentSessionsStorage?
    var keyValueStorage: TypedKeyValueStorage

    // Variables to track method calls and their arguments
    var startCalled = false
    var stopCalled = false
    var notifyAppStartedCalled = false
    var notifyAppStartedForceUpdate = false
    var addedIdentities: [SplitIdentity] = []
    var removedIdentities: [SplitIdentity] = []
    var clearIdentitiesCalled = false

    init(keyValueStorage: TypedKeyValueStorage) {
        self.keyValueStorage = keyValueStorage
        // Initialize other properties if needed
    }

    func start() {
        startCalled = true
    }

    func stop() {
        stopCalled = true
    }

    func notifyAppStarted(forceUpdate: Bool) {
        notifyAppStartedCalled = true
        notifyAppStartedForceUpdate = forceUpdate
    }

    func add(identities: [SplitIdentity]) {
        addedIdentities.append(contentsOf: identities)
    }

    func remove(identities: [SplitIdentity]) {
        removedIdentities.append(contentsOf: identities)
    }

    func clearIdentities() {
        clearIdentitiesCalled = true
        identities.removeAll()
    }

    func timeSinceStart() -> Int64 {
        return Int64(Date().timeIntervalSince1970) - startTime
    }
}

