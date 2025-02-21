//
//  URL+.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import Foundation

extension URL {
    
    mutating func appendQueryItem(name: String, value: String?) {
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        queryItems.append(.init(name: name, value: value))
        urlComponents.queryItems = queryItems
        
        self = urlComponents.url!
    }
}
