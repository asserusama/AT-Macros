//
//  ATMacros.swift
//  ATMacros
//
//  Created by Asser on 22/07/2025.
//

@attached(peer, names: overloaded)
public macro Async() = #externalMacro(module: "ATMacrosMacros", type: "Async")
