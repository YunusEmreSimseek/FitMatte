//
//  SuggestionModels.swift
//  FitMatte
//
//  Created by Emre Simsek on 24.10.2025.
//

struct SuggestionPayload: Decodable {
    let answer: String
    let suggestion: Suggestion?
}

struct Suggestion: Decodable {
    let type: String
    let title: String
    let description: String
    let action: SuggestionAction
}

struct SuggestionAction: Decodable {
    let type: String
    let value: SuggestionActionValue
}

extension Suggestion {
    static let dummy = Suggestion(
        type: "example",
        title: "This is an AI-generated suggestion.",
        description: "This is a dummy description for the AI-generated suggestion.",
        action: SuggestionAction(type: "example", value: .int(1))
    )
}
