//
//  HomeViewModelTests.swift
//  poq-taskTests
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import Foundation
import Combine
import XCTest
@testable import poq_task

final class HomeViewModelTests: XCTestCase {
    
    // MARK: Properties
    
    private var router: MockHomeRouter!
    private var repoService: MockRepoService!
    private var subject: HomeViewModeling!
    
    // MARK: Setup
    
    override func setUp() {
        repoService = MockRepoService()
        router = MockHomeRouter()
        
        setupRepoMockData()
        
        subject = HomeViewModel(
            router: router,
            repoService: repoService
        )
    }
    
    // MARK: Tests

    func test_tableViewPaginationPublisher_shouldEmitPaginationStates() {
        // GIVEN
        let expectation = expectation(description: "Should emit correct pagination states")
        var receivedStates: [LoadingState] = []
        let cancellable = subject.tableViewPagination
            .sink { state in
                receivedStates.append(state)
            }
        
        // WHEN
        subject.onTableViewWillDisplayCell(for: IndexPath(row: 14, section: 0))
        
        // THEN
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(receivedStates.contains(.loading), "Should include loading state")
            XCTAssertTrue(receivedStates.contains(.finished), "Should include finished state")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        cancellable.cancel()
    }
    
    func test_onRepoSelection_shouldOpenExternalBrowser() {
        // GIVEN
        let cellRow = 3
        let indexPath = IndexPath(row: cellRow, section: 0)
        
        // WHEN
        subject.onRepoSelection(indexPath)
        
        // THEN
        XCTAssertTrue(router.presentBrowserCalled)
        XCTAssertEqual(router.presentBrowserReceivedUrl, "repo_link_\(cellRow + 1)")
    }
    
    func test_onBottomScroll_shouldLoadMoreRepos() {
        // GIVEN
        let expectation = expectation(description: "Should fetch more repositories")
        var receivedStates: [LoadingState] = []
        let cancellable = subject.tableViewPagination
            .sink { state in
                receivedStates.append(state)
            }
        
        repoService.getReposListClosure = { organizationName, page in
            XCTAssertEqual(page, 2)
            expectation.fulfill()
        }
        
        // WHEN
        subject.onTableViewWillDisplayCell(for: IndexPath(row: 14, section: 0))
        
        // THEN
        XCTAssertTrue(repoService.getReposListCalled)
        XCTAssertEqual(receivedStates, [.finished, .loading, .finished])
        
        wait(for: [expectation], timeout: 1)
        cancellable.cancel()
    }
    
    // MARK: Private
    
    private func setupRepoMockData() {
        var repoList: Model.RepoList = []
        for i in 1...20 {
            repoList.append(Model.Repo(
                id: i,
                name: "Repo \(i)",
                fullName: "Repo \(i)",
                description: "Description \(i)",
                stargazersCount: i,
                language: "Swift",
                forks: i,
                openIssues: i,
                watchers: i,
                url: "repo_link_\(i)",
                ownerAvatarUrl: "avatar_\(i)"
            ))
        }
        
        repoService.getReposListReturnValue = Just(repoList)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
}
