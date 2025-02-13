//
//  poq_task_UITests.swift
//  poq-task-UITests
//
//  Created by Hercig, Filip (148) on 13.02.25.
//

import XCTest

final class HomeScreenUITests: XCTestCase {

    // MARK: Properties
    
    private let app = XCUIApplication()
    
    // MARK: Setup

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    // MARK: Tests

    func test_openingApp_shouldLoadRepositories() {
        let firstCell = app.cells["homeRepoCell1"]
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "Repo list did not load")
        
        let secondCell = app.cells["homeRepoCell2"]
        XCTAssertTrue(secondCell.waitForExistence(timeout: 5), "Repo list did not load")
        
        let thirdCell = app.cells["homeRepoCell3"]
        XCTAssertTrue(thirdCell.waitForExistence(timeout: 5), "Repo list did not load")
    }

    func test_userTapsOnRepo_shouldOpenBrowser() {
        let firstRepo = app.cells["homeRepoCell1"]
        XCTAssertTrue(firstRepo.waitForExistence(timeout: 5), "First repo cell should exist")
        
        firstRepo.tap()
        
        let safariView = app.windows.firstMatch
        XCTAssertTrue(safariView.waitForExistence(timeout: 5), "Browser did not open")
        
        let doneButton = app.buttons["Done"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 5), "Done button not found")
        
        doneButton.tap()
        XCTAssertTrue(firstRepo.waitForExistence(timeout: 5), "Main screen did not reappear after closing SafariView")
    }

    func test_scrollThroughRepos() {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.exists, "Repo list should exist")

        tableView.swipeUp()
        tableView.swipeDown()
    }
    
    func test_pullToRefresh() {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.exists, "Repo list should exist")

        let firstCell = app.cells["homeRepoCell0"]
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "First repo cell should exist")

        tableView.swipeDown()

        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "Repo list did not reload after pull-to-refresh")
    }
}
