import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct Async: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // This logic remains the same
        guard let funcDecl = declaration.as(FunctionDeclSyntax.self) else {
            throw AsyncError.onlyFunction
        }
        let params = funcDecl.signature.parameterClause.parameters
        guard let lastParam = params.last else {
            throw AsyncError.noCompletionHandler
        }
        let originalCompletionType = lastParam.type
        let baseCompletionType = originalCompletionType.as(AttributedTypeSyntax.self)?.baseType ?? originalCompletionType
        let typeName = baseCompletionType.trimmedDescription
        let analysis: CompletionHandlerAnalysis

        if let resolvedTypeName = TypeAliasDictionary.aliasRegistry[typeName] {
            analysis = CompletionHandlerAnalysis(
                successType: TypeSyntax(stringLiteral: resolvedTypeName),
                isThrowing: true
            )
        } else {
            guard let closureType = parseFunctionType(from: originalCompletionType) else {
                throw AsyncError.invalidCompletionHandler
            }
            guard let resolvedAnalysis = analyzeCompletionHandler(closureType) else {
                throw AsyncError.invalidCompletionHandler
            }
            analysis = resolvedAnalysis
        }

        let returnType = analysis.successType
        let isThrowing = analysis.isThrowing
        let funcName = funcDecl.name.text
        let asyncParams = buildAsyncFunctionParameters(from: params.dropLast())
        let callArgs = buildOriginalFunctionCallArguments(from: params.dropLast())

        let callSite: String = if callArgs.isEmpty {
            "self.\(funcName)"
        } else {
            "self.\(funcName)(\(callArgs))"
        }

        // --- **FINAL FIX IS HERE** ---
        let asyncDecl: DeclSyntax = if isThrowing {
            """
            func \(raw: funcName)(\(raw: asyncParams)) async throws -> \(returnType) {
                try await withCheckedThrowingContinuation { continuation in
                    \(raw: callSite) { result in
                        switch result {
                        case .success(let result):
                            continuation.resume(returning: result)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
            }
            """
        } else {
            // The non-throwing logic remains the same
            if returnType.trimmedDescription == "Void" {
                """
                func \(raw: funcName)(\(raw: asyncParams)) async {
                    await withCheckedContinuation { continuation in
                        \(raw: callSite) {
                            continuation.resume()
                        }
                    }
                }
                """
            } else {
                """
                func \(raw: funcName)(\(raw: asyncParams)) async -> \(returnType) {
                    await withCheckedContinuation { continuation in
                        \(raw: callSite) { value in
                            continuation.resume(returning: value)
                        }
                    }
                }
                """
            }
        }

        return [asyncDecl]
    }
}
