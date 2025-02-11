//
//  LoadingState.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import Foundation

enum LoadingState {

    case empty
    case loading
    case finished
    case failed(Error)

    static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty), (.loading, .loading), (.finished, .finished), (.failed(_), .failed(_)):
            return true
        default:
            return false
        }
    }

    static func != (lhs: LoadingState, rhs: LoadingState) -> Bool {
        !(lhs == rhs)
    }
}
