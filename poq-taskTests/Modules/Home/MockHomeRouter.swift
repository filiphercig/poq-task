//
//  MockHomeRouter.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import XCTest
@testable import poq_task

final class MockHomeRouter: HomeRouting {

    // MARK: presentBrowser

    var presentBrowserCallsCount = 0
    var presentBrowserCalled: Bool {
        return presentBrowserCallsCount > 0
    }
    var presentBrowserReceivedUrl: String?
    var presentBrowserClosure: ((String) -> Void)?

    func presentBrowser(with url: String) {
        presentBrowserCallsCount += 1
        presentBrowserReceivedUrl = url
        presentBrowserClosure?(url)
    }
}
