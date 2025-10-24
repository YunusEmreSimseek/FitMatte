//
//  UserAuthServiceProtocol.swift
//  FitMatte
//
//  Created by Emre Simsek on 17.10.2025.
//
import FirebaseAuth

/// Authentication service protocol
protocol UserAuthServiceProtocol {
    /// Method for signing up with email and password
    func signUp(email: String, password: String) async throws -> AuthDataResult

    /// Method for signing in with email and password
    func signIn(email: String, password: String) async throws -> AuthDataResult

    /// Method for signing out
    func signOut() -> Bool

    /// Method for checking if user is authenticated
    func checkAuthUser() -> User?
}

extension UserAuthServiceProtocol {
    var db: Auth {
        return Auth.auth()
    }
}
