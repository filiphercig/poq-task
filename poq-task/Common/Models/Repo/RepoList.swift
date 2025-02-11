//
//  RepoList.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import Foundation

extension Model {
    
    typealias RepoList = [Repo]
    
    struct Repo {
        let id: Int
        let name: String
        let fullName: String
        let description: String?
        let stargazersCount: Int
        let language: String?
        let forks: Int
        let openIssues: Int
        let watchers: Int
        let url: String
    }
}
