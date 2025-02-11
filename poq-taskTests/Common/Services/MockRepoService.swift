//
//  MockRepoService.swift
//  poq-taskTests
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import Foundation
import Combine
@testable import poq_task

final class MockRepoService: RepoServicing {
    
    // MARK: getReposList

    var getReposListCallsCount = 0
    var getReposListCalled: Bool {
        return getReposListCallsCount > 0
    }
    var getReposListReceivedUserID: String?
    var getReposListClosure: ((String) -> Void)?
    var getReposListReturnValue: AnyPublisher<Model.RepoList, NetworkError>?
    
    func getReposList(for userID: String) -> AnyPublisher<Model.RepoList, NetworkError> {
        getReposListCallsCount += 1
        getReposListReceivedUserID = userID
        getReposListClosure?(userID)
        return getReposListReturnValue ?? Empty<Model.RepoList, NetworkError>().eraseToAnyPublisher()
    }
}
