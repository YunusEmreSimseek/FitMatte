//
//  UserSessionManager.swift
//  FitMatte
//
//  Created by Emre Simsek on 17.10.2025.
//
import Combine

final class UserSessionManager {
    @Published private(set) var currentUser: UserModel?

    var isLoggedIn: Bool {
        currentUser != nil
    }

    func clearSession() {
        currentUser = nil
        print("User session cleared.")
    }

    func updateSession(_ user: UserModel) {
        currentUser = user
        print("User session updated")
    }

    func updateUser(_ user: UserModel) async {
        currentUser = user
//        guard let user = currentUser else { return }
    }
}
