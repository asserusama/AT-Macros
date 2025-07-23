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
        // If the completion handler takes no parameters, it's a non-throwing function that returns Void.
        guard let completionParameter = closure.parameters.first else {
            let voidType = TypeSyntax(stringLiteral: "Void")
            return CompletionHandlerAnalysis(successType: voidType, isThrowing: false)
        }

        // Check if the parameter is a Result or APIResult type.
        if let resultType = completionParameter.type.as(IdentifierTypeSyntax.self),
           (resultType.name.text == "Result" || resultType.name.text == "APIResult"),
           let genericArgs = resultType.genericArgumentClause?.arguments,
           let firstGenericArgument = genericArgs.first {

            // The success type is the first generic argument.
            let successTypeString = firstGenericArgument.argument.description.trimmingCharacters(in: .whitespaces)
            let successType = TypeSyntax(stringLiteral: successTypeString)

            return CompletionHandlerAnalysis(successType: successType, isThrowing: true)
        }

        // Otherwise, it's a non-throwing function where the parameter is the return value.
        return CompletionHandlerAnalysis(successType: completionParameter.type, isThrowing: false)
    }

    static func buildAsyncFunctionParameters<S: Sequence>(from parameters: S) -> String where S.Element == FunctionParameterSyntax {
        parameters.map { parameter in
            parameter
                .with(\.trailingComma, nil)
                .description
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }.joined(separator: ", ")
    }

    static func buildOriginalFunctionCallArguments<S: Sequence>(from parameters: S) -> String where S.Element == FunctionParameterSyntax {
        parameters.map { parameter in
            let argumentLabel = parameter.firstName.text
            let variableName = parameter.secondName?.text ?? argumentLabel
            return "\(argumentLabel): \(variableName)"
        }.joined(separator: ", ")
    }
}
