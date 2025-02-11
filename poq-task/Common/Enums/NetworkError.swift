//
//  NetworkError.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {

    case invalidRequest
    case error4xx(_ code: Int)
    case error5xx(_ code: Int)
    case decodingError
    case unknownError
}
