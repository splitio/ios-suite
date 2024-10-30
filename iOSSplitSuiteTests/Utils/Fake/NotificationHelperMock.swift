//
//  NotificationHelperMock.swift
//  iOSSplitSuiteTests
//
//  Created by Javier Avrudsky on 13/03/2024.
//

import Foundation
@testable import iOSSplitSuite
@testable import Split

class NotificationHelperMock: NotificationHelper {
    func addObserver(for notification: AppNotification, action: @escaping ObserverAction) {

    }

    func removeAllObservers() {

    }

    func post(notification: AppNotification, info: AnyObject?) {

    }

}
