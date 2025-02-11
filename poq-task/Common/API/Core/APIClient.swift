//
//  APIClient.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import Foundation
import Combine

protocol APIClientProtocol {
    func performRequest<T: APIRequest>(_ request: T) -> AnyPublisher<T.ResponseType, NetworkError>
}

final class APIClient: APIClientProtocol {

    static let shared = APIClient()
    
    // MARK: Private
    
    private let decoder = JSONDecoder()

    // MARK: Init

    private init() {}

    // MARK: Public

    func performRequest<T: APIRequest>(_ request: T) -> AnyPublisher<T.ResponseType, NetworkError> {

        guard let request = request.urlRequest() else {
            return Fail(error: NetworkError.invalidRequest)
                .eraseToAnyPublisher()
        }

        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .mapError { _ in NetworkError.unknownError }
            .flatMap { [weak self] data, response -> AnyPublisher<T.ResponseType, NetworkError> in

                guard let self else {
                    return Fail(error: NetworkError.unknownError)
                        .eraseToAnyPublisher()
                }

                if let response = response as? HTTPURLResponse {
                    
                    switch response.statusCode {
                    case 200...299:
                        return Just(data)
                            .decode(type: T.ResponseType.self, decoder: self.decoder)
                            .mapError { error in
                                return NetworkError.decodingError
                            }
                            .eraseToAnyPublisher()

                    case 400...499:
                        return Fail(error: NetworkError.error4xx(response.statusCode))
                            .eraseToAnyPublisher()

                    case 500...599:
                        return Fail(error: NetworkError.error5xx(response.statusCode))
                            .eraseToAnyPublisher()

                    default:
                        return Fail(error: NetworkError.unknownError)
                            .eraseToAnyPublisher()
                    }
                }

                return Fail(error: NetworkError.unknownError)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

