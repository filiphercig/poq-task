//
//  APIRequest.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import Foundation

protocol APIRequest {

    associatedtype ResponseType: Decodable

    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var query: [String: String?]? { get }
    var body: Data? { get }
}

extension APIRequest {

    func urlRequest() -> URLRequest? {
        guard let url = URL(string: path) else { return nil }

        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.httpBody = body
        
        urlRequest.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        urlRequest.setValue("", forHTTPHeaderField: "If-None-Match")

        if let query {
            query.forEach { urlRequest.url?.appendQueryItem(name: $0.key, value: $0.value) }
        }

        return urlRequest
    }
}
