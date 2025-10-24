//
//  UserSessionManager.swift
//  FitMatte
//
//  Created by Emre Simsek on 17.10.2025.
//
import Combine

final class UserSessionManager {
    @Published private(set) var currentUser: UserModel?
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = AppContainer.shared.userService) {
        self.userService = userService
    }

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
        do {
            try await userService.updateUser(user: user)
            currentUser = user
        } catch {
            print("Failed to update user: \(error)")
            return
        }
    }
}
