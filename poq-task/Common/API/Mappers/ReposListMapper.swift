//
//  ReposListMapper.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import Foundation

struct ReposListMapper {
    
    static func map(_ repos: APIModel.RepoList) -> Model.RepoList {
        repos.map { apiRepoModel in
            Model.Repo(
                id: apiRepoModel.id,
                name: apiRepoModel.name,
                fullName: apiRepoModel.fullName,
                description: apiRepoModel.description,
                stargazersCount: apiRepoModel.stargazersCount,
                language: apiRepoModel.language,
                forks: apiRepoModel.forks,
                openIssues: apiRepoModel.openIssues,
                watchers: apiRepoModel.watchers,
                url: apiRepoModel.url
            )
        }
    }
}
