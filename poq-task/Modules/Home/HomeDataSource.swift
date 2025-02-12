//
//  HomeDataSource.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import UIKit

// MARK: - HomeCellType

enum HomeCellType {
    case reposCell(Model.Repo)
}

// MARK: - HomeDataSource

final class HomeDataSource: NSObject {

    // MARK: Private Properties

    private var items: [HomeCellType] = []
    private var repos: Model.RepoList?

    // MARK: Public Methods
    
    func createCells(repos: Model.RepoList, isPaginating: Bool = false) {
        if !isPaginating {
            items.removeAll()
        }

        repos.forEach { repo in
            items.append(.reposCell(repo))
        }
    }

    func getCell(for indexPath: IndexPath) -> HomeCellType {
        items[indexPath.row]
    }

    var numberOfCells: Int {
        items.count
    }
}

// MARK: - UITableViewDataSource

extension HomeDataSource: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch items[indexPath.row] {
        case .reposCell(let repo):
            let cell: HomeRepoCell = tableView.dequeueCellAtIndexPath(indexPath: indexPath)
            cell.update(repo: repo)

            return cell
        }
    }
}
