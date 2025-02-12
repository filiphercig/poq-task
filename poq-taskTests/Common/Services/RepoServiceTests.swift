//
//  RepoServiceTests.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 12.02.25.
//

import Foundation
import Combine
import XCTest
@testable import poq_task

final class RepoServiceTests: XCTestCase {
    
    // MARK: Properties
    private var cancellables: Set<AnyCancellable>!
    
    private var apiClient: MockAPIClient!
    private var subject: RepoService!
    
    // MARK: Setup
    
    override func setUp() {
        apiClient = MockAPIClient()
        cancellables = []
        subject = RepoService(apiClient: apiClient)
    }
    
    // MARK: Tests
        
    func test_getReposList_successfulResponse() throws {
        // GIVEN
        let mockReposList: APIModel.RepoList = [
            .init(
                id: 1,
                name: "TestRepo",
                fullName: "",
                description: "",
                owner: .init(id: 1, avatarURL: "", gravatarID: "", url: "", followersURL: ""),
                stargazersCount: 9,
                language: nil,
                forks: 3,
                openIssues: 1,
                watchers: 1,
                url: "",
                openIssuesCount: 1
            )
        ]
        
        let mockData = try JSONEncoder().encode(mockReposList)
        apiClient.addMockResponse(
            for: GetReposListRequest(userID: "", page: 1),
            result: .success(mockData)
        )
        
        let expectation = self.expectation(description: "Successful response received")
        
        // WHEN
        subject.getReposList(for: "", page: 1)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but received failure")
                }
            }, receiveValue: { receivedReposList in
                // THEN
                XCTAssertEqual(receivedReposList.count, 1)
                XCTAssertEqual(receivedReposList.first?.name, "TestRepo")
                XCTAssertEqual(receivedReposList.first?.forks, 3)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_getReposList_networkErrorResponse() {
        // GIVEN
        apiClient.addMockResponse(for: GetReposListRequest(userID: "", page: 1), result: .failure(NetworkError.error4xx(401)))
        
        let expectation = self.expectation(description: "Failure response received")
        
        // WHEN
        subject.getReposList(for: "", page: 1)
            .sink(receiveCompletion: { completion in
                // THEN
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, NetworkError.error4xx(401))
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure but received success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but received success")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_getReposList_decodingErrorResponse() {
        // GIVEN
        let invalidJSONData = "Invalid JSON".data(using: .utf8)!
        apiClient.addMockResponse(for: GetReposListRequest(userID: "", page: 1), result: .success(invalidJSONData))
        
        let expectation = self.expectation(description: "Decoding failure response received")
        
        // WHEN
        subject.getReposList(for: "", page: 1)
            .sink(receiveCompletion: { completion in
                // THEN
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, NetworkError.decodingError)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure but received success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but received success")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
