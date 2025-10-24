//
//  UserServiceError.swift
//  FitMatte
//
//  Created by Emre Simsek on 17.10.2025.
//
import Foundation

enum UserServiceError: LocalizedError {
    case invalidUserID
    case userNotFound
    case parsingError
    case unknownError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidUserID:
            return "Invalid user ID."
        case .userNotFound:
            return "The user could not be found."
        case .parsingError:
            return "Failed to parse user data."
        case let .unknownError(error):
            return "Unexpected error: \(error.localizedDescription)"
        }
    }
}

