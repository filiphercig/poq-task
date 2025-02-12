//
//  APIRepoListModel.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import Foundation

extension APIModel {
    
    typealias RepoList = [Repo]
    
    struct Repo: Codable {
        let id: Int
        let name: String
        let fullName: String
        let description: String?
        let owner: Owner
        let stargazersCount: Int
        let language: String?
        let forks: Int
        let openIssues: Int
        let watchers: Int
        let url: String
        let openIssuesCount: Int

        enum CodingKeys: String, CodingKey {
            case id, name
            case fullName = "full_name"
            case description, owner
            case stargazersCount = "stargazers_count"
            case language, forks
            case openIssues = "open_issues"
            case watchers
            case url = "html_url"
            case openIssuesCount = "open_issues_count"
        }
        
        struct Owner: Codable {
            let id: Int
            let avatarURL: String
            let gravatarID: String
            let url: String
            let followersURL: String

            enum CodingKeys: String, CodingKey {
                case id
                case avatarURL = "avatar_url"
                case gravatarID = "gravatar_id"
                case url
                case followersURL = "followers_url"
            }
        }
    }
}
