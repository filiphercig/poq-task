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
    private var subject: HomeViewModel!
    
    // MARK: Setup
    
    override func setUp() {
        repoService = MockRepoService()
        router = MockHomeRouter()
        
        setupRepoMockData()
        
        subject = .init(
            router: router,
            repoService: repoService
        )
    }
    
    // MARK: Tests
    
    func test_onRepoSelection_shouldOpenExternalBrowser() {
        // GIVEN
        let indexPath = IndexPath(row: 0, section: 0)
        
        // WHEN
        subject.onRepoSelection(indexPath)
        
        // THEN
        XCTAssertTrue(router.presentBrowserCalled)
        XCTAssertEqual(router.presentBrowserReceivedUrl, "first_link")
    }
    
    // MARK: Private
    
    private func setupRepoMockData() {
        let repoList: Model.RepoList = [
            Model.Repo(
                id: 1,
                name: "First",
                fullName: "First",
                description: "Description 1",
                stargazersCount: 1,
                language: nil,
                forks: 1,
                openIssues: 1,
                watchers: 2,
                url: "first_link"
            ),
            Model.Repo(
                id: 2,
                name: "Second",
                fullName: "Second",
                description: nil,
                stargazersCount: 2,
                language: nil,
                forks: 1,
                openIssues: 0,
                watchers: 0,
                url: "second_link"
            )
        ]
        repoService.getReposListReturnValue = Just(repoList)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
}
