//
//  GetReposListRequest.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import Foundation

struct GetReposListRequest: APIRequest {
    
    typealias ResponseType = APIModel.RepoList

    let path: String
    let httpMethod: HTTPMethod = .get
    var query: [String : String?]? = [:]
    var body: Data?

    init(userID: String, page: Int) {
        path = APIEndpoint.getReposList(userID: userID).path
        
        query?["per_page"] = "\(Constants.API.repoPaginationSize)"
        query?["page"] = "\(page)"
    }
}
