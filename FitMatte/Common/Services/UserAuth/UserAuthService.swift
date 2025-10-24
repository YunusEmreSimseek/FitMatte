//
//  UserAuthService.swift
//  FitMatte
//
//  Created by Emre Simsek on 17.10.2025.
//
import FirebaseAuth

final class UserAuthService: UserAuthServiceProtocol {
    func signUp(email: String, password: String) async throws -> AuthDataResult {
        do {
            let response = try await db.createUser(withEmail: email, password: password)
            return response

        } catch {
            let mappedError = self.mapFirebaseError(error)
            throw mappedError
        }
    }

    func signIn(email: String, password: String) async throws -> AuthDataResult {
        do {
            let response = try await db.signIn(withEmail: email, password: password)
            return response
        } catch {
            let mappedError = self.mapFirebaseError(error)
            throw mappedError
        }
    }

    func signOut() -> Bool {
        do {
            try db.signOut()
            return true
        } catch {
            return false
        }
    }

    func checkAuthUser() -> User? {
        let user = db.currentUser
        return user
    }
}

extension UserAuthService {
    private func mapFirebaseError(_ error: Error) -> UserAuthServiceError {
        let errorCode = (error as NSError).code

        switch errorCode {
        case AuthErrorCode.invalidEmail.rawValue:
            return .invalidEmail
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .emailAlreadyInUse
        case AuthErrorCode.weakPassword.rawValue:
            return .weakPassword
        case AuthErrorCode.wrongPassword.rawValue:
            return .wrongPassword
        case AuthErrorCode.userNotFound.rawValue:
            return .userNotFound
        default:
            return .unknownError
        }
    }
}
