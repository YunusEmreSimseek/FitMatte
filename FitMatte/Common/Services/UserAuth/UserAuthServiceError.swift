//
//  UserAuthServiceError.swift
//  FitMatte
//
//  Created by Emre Simsek on 17.10.2025.
//

enum UserAuthServiceError: Error {
    case invalidEmail
    case emailAlreadyInUse
    case weakPassword
    case wrongPassword
    case userNotFound
    case unknownError
    case passwordsDoNotMatch
    case emptyName
    case emptyEmail
    case emptyPassword
}

extension UserAuthServiceError {
    var userFriendlyMessage: String {
        switch self {
        case .invalidEmail:
            return "Invalid email format."
        case .emailAlreadyInUse:
            return "Email is already registered."
        case .weakPassword:
            return "Password is too weak."
        case .wrongPassword:
            return "Incorrect password."
        case .userNotFound:
            return "User not found."
        case .unknownError:
            return "An unknown error occurred."
        case .passwordsDoNotMatch:
            return "Passwords do not match."
        case .emptyName:
            return "Name cannot be empty."
        case .emptyEmail:
            return "Email cannot be empty."
        case .emptyPassword:
            return "Password cannot be empty."
        }
    }
}
