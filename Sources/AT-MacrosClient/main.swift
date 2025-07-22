//
//  main.swift
//  AT-Macros
//
//  Created by Asser on 22/07/2025.
//

import AT_Macros

struct AsyncFunctions {
    @Async
    func tsasaest(arg1: String, completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success("Hello, \(arg1)"))
    }
}

