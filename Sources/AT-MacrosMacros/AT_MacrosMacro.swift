//
//  AT_MaacrosMacro.swift
//  AT-Macros
//
//  Created by Asser on 22/07/2025.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct Async: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let funcDecl = declaration.as(FunctionDeclSyntax.self) else {
            throw AsyncError.onlyFunction
        }

        let params = funcDecl.signature.parameterClause.parameters
        guard let lastParam = params.last else {
            throw AsyncError.noCompletionHandler
        }

        // Use the new, safer helper methods
        guard let closureType = parseFunctionType(from: lastParam.type) else {
            throw AsyncError.invalidCompletionHandler
        }

        guard let analysis = analyzeCompletionHandler(closureType) else {
            throw AsyncError.invalidCompletionHandler
        }

        let returnType = analysis.successType
        let isThrowing = analysis.isThrowing

        let funcName = funcDecl.name.text
        let asyncParams = buildAsyncFunctionParameters(from: params.dropLast())
        let callArgs = buildOriginalFunctionCallArguments(from: params.dropLast())

        // Use the cleaner, more idiomatic code generation
        let asyncDecl: DeclSyntax = if isThrowing {
            """
            func \(raw: funcName)(\(raw: asyncParams)) async throws -> \(returnType) {
                try await withCheckedThrowingContinuation { continuation in
                    \(raw: funcName)(\(raw: callArgs)) { result in
                        continuation.resume(with: result)
                    }
                }
            }
            """
        } else {
            """
            func \(raw: funcName)(\(raw: asyncParams)) async -> \(returnType) {
                await withCheckedContinuation { continuation in
                    \(raw: funcName)(\(raw: callArgs))(continuation.resume(returning:))
                }
            }
            """
        }

        return [asyncDecl]
    }
}
