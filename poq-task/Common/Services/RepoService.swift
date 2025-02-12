//
//  RepoService.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import Foundation
import Combine

protocol RepoServicing {
    func getReposList(for userID: String, page: Int) -> AnyPublisher<Model.RepoList, NetworkError>
}

final class RepoService: RepoServicing {
    
    // MARK: Private
    
    private let apiClient: APIClientProtocol
    
    // MARK: Init
    
    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    // MARK: Public

    func getReposList(for userID: String, page: Int) -> AnyPublisher<Model.RepoList, NetworkError> {
        let request = GetReposListRequest(userID: userID, page: page)
        
        return apiClient.performRequest(request)
            .map { ReposListMapper.map($0) }
            .eraseToAnyPublisher()
    }
}
