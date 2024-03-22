//
//  SplitFactoryMock.swift
//  iOSSplitSuiteTests
//
//  Created by Javier Avrudsky on 29/01/2024.
//

@testable import iOSSplitSuite
@testable import Split

// Assuming SplitClient, SplitManager, Key, and UserConsent are defined elsewhere
// and conform to their respective protocols/interfaces

class SplitFactoryMock: SplitFactory {
    var clients = Set<String>()
    var client: SplitClient

    var manager: SplitManager = SplitManagerMock()
    var userConsent: UserConsent = .unknown
    var version: String = "2.0.0"

    // Tracking variables for method calls
    var setUserConsentCalled: Bool = false

    init() {
        client = SplitClientMock()
        self.clients.insert("defaultKey")
    }

    func client(key: Key) -> SplitClient {

        self.clients.insert(key.stringRepresentation())
        return self.client
    }

    func client(matchingKey: String) -> SplitClient {
        clients.insert(matchingKey)
        return self.client
    }

    func client(matchingKey: String, bucketingKey: String?) -> SplitClient {
        // Return a SplitClient instance based on the matchingKey and bucketingKey
        return self.client
    }

    func setUserConsent(enabled: Bool) {
        setUserConsentCalled = true
        userConsent = enabled ? .granted : .declined
    }
}

class SplitManagerMock: SplitManager {
    var splits: [SplitView]  {
        return []
    }

    var splitNames: [String] {
        return []
    }

    func split(featureName: String) -> SplitView? {
        return nil
    }
}
