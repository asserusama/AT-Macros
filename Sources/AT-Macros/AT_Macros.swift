//
//  AT_Maacros.swift
//  AT-Macros
//
//  Created by Asser on 22/07/2025.
//

@attached(peer, names: overloaded)
public macro Async() = #externalMacro(module: "AT_MacrosMacros", type: "Async")

