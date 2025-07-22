//
//  HelperMethods.swift
//  AT-Macros
//
//  Created by Asser on 22/07/2025.
//

import SwiftSyntax
import Foundation

struct CompletionHandlerAnalysis {
    let successType: TypeSyntax
    let isThrowing: Bool
}

extension Async {
    static func parseFunctionType(from type: TypeSyntax) -> FunctionTypeSyntax? {
        if let functionType = type.as(FunctionTypeSyntax.self) {
            return functionType
        }

        if let attributedType = type.as(AttributedTypeSyntax.self) {
            return attributedType.baseType.as(FunctionTypeSyntax.self)
        }

        return nil
    }

    static func analyzeCompletionHandler(_ closure: FunctionTypeSyntax) -> CompletionHandlerAnalysis? {
        guard let completionParameter = closure.parameters.first else {
            let voidType = TypeSyntax(stringLiteral: "Void")
            return CompletionHandlerAnalysis(successType: voidType, isThrowing: false)
        }

        if let resultType = completionParameter.type.as(IdentifierTypeSyntax.self),
           resultType.name.text == "Result",
           let genericArgs = resultType.genericArgumentClause?.arguments,
           let firstGenericArgument = genericArgs.first {
            let successTypeString = firstGenericArgument.argument.description.trimmingCharacters(in: .whitespaces)
            let successType = TypeSyntax(stringLiteral: successTypeString)

            return CompletionHandlerAnalysis(successType: successType, isThrowing: true)
        }

        return CompletionHandlerAnalysis(successType: completionParameter.type, isThrowing: false)
    }

    static func buildAsyncFunctionParameters<S: Sequence>(from parameters: S) -> String where S.Element == FunctionParameterSyntax {
        parameters.map(\.description).joined(separator: ", ")
    }

    static func buildOriginalFunctionCallArguments<S: Sequence>(from parameters: S) -> String where S.Element == FunctionParameterSyntax {
        parameters.map { parameter in
            let argumentLabel = parameter.firstName.text
            let variableName = parameter.secondName?.text ?? argumentLabel
            return "\(argumentLabel): \(variableName)"
        }.joined(separator: ", ")
    }
}
