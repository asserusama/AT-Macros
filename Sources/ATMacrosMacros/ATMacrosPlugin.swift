//
//  ATMacrosPlugin.swift
//  ATMacros
//
//  Created by Asser on 22/07/2025.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct ATMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        Async.self
    ]
}
