//
//  AsyncErrors.swift
//  AT-Macros
//
//  Created by Asser on 22/07/2025.
//

enum AsyncError: Error {
    case onlyFunction
    case noCompletionHandler
    case invalidCompletionHandler

    var description: String {
        switch self {
        case .onlyFunction:
            return "@Async can be attached only to functions."
        case .noCompletionHandler:
            return "@Async requires a function with a completion handler parameter."
        case .invalidCompletionHandler:
            return "@Async requires the last parameter to be a closure of type Result<T, Error> or T."
        }
    }
}
