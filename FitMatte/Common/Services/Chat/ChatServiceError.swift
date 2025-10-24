//
//  ChatServiceError.swift
//  FitMatte
//
//  Created by Emre Simsek on 20.10.2025.
//
import Foundation

enum ChatServiceError: LocalizedError {
    case chatNotFound
    case decodingError
    case networkError(Error)
    case unknownError(Error)

    var errorDescription: String? {
        switch self {
        case .chatNotFound:
            return "Chat could not be found."
        case .decodingError:
            return "Failed to decode chat data."
        case let .networkError(error):
            return "Network error: \(error.localizedDescription)"
        case let .unknownError(error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
