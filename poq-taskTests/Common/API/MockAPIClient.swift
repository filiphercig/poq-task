//
//  MockAPIClient.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import Foundation
import Combine
@testable import poq_task

final class MockAPIClient: APIClientProtocol {
    
    // MARK: Properties

    private var mockResponses: [String: Result<Data, NetworkError>] = [:]

    // MARK: Methods
    
    func addMockResponse<T: APIRequest>(for request: T, result: Result<Data, NetworkError>) {
        let key = "\(T.self)"
        mockResponses[key] = result
    }
    
    func clearMockResponses() {
        mockResponses.removeAll()
    }

    func performRequest<T: APIRequest>(_ request: T) -> AnyPublisher<T.ResponseType, NetworkError> {
        let key = "\(T.self)"

        if let result = mockResponses[key] {
            switch result {
            case .success(let data):
                return Just(data)
                    .decode(type: T.ResponseType.self, decoder: JSONDecoder())
                    .mapError { _ in NetworkError.decodingError }
                    .eraseToAnyPublisher()

            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
            }
        } else {
            return Fail(error: NetworkError.unknownError).eraseToAnyPublisher()
        }
    }
}
