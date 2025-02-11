//
//  APIRepoListModel.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import Foundation

extension APIModel {
    
    typealias RepoList = [Repo]
    
    struct Repo: Decodable {
        let id: Int
        let name: String
        let fullName: String
        let description: String?
        let owner: Owner
        let license: License?
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
            case description, owner, license
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
        
        struct License: Decodable {
            let key: LicenceKey
            let name: LicenceName
            let url: String?
        }
        
        enum LicenceKey: String, Decodable {
            case apache20 = "apache-2.0"
            case mit = "mit"
            case other = "other"
        }
        
        enum LicenceName: String, Decodable {
            case apacheLicense20 = "Apache License 2.0"
            case mitLicense = "MIT License"
            case other = "Other"
        }
    }
}
