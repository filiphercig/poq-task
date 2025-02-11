//
//  APIEndpoint.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import Foundation

enum APIEndpoint {

    // MARK: Endpoints

    case getReposList(userID: String)

    // MARK: Private

    private var subPath: String {

        switch self {
        case .getReposList(let userID):
            "/orgs/\(userID)/repos"
        }
    }
    
    // MARK: Public
    
    var path: String { Constants.API.baseUrl + subPath }
}
