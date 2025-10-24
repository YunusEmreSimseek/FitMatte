//
//  AIServiceProtocol.swift
//  FitMatte
//
//  Created by Emre Simsek on 24.10.2025.
//
import Foundation

protocol AIServiceProtocol {
    func sendMessage(_ messages: [MessageModel]) async throws -> SuggestionPayload
}


