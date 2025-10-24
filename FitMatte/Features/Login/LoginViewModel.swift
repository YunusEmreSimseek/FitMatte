//
//  LoginViewModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 7.10.2025.
//
import Combine
import Foundation
import UIKit
import FirebaseAuth

final class LoginViewModel: BaseViewModel {
    @Published private(set) var emailValue = ""
    @Published private(set) var passwordValue = ""
    @Published private(set) var isLoginEnabled = false
    @Published private(set) var errorMessage: String?
    private let userAuthService: UserAuthServiceProtocol
    private let userService: UserServiceProtocol
    private let dietManager: DietManager
    private let workoutManager: WorkoutManager
    private let userSessionManager: UserSessionManager
    private let navigationManager: NavigationManager
     init(
        userAuthService: UserAuthServiceProtocol = AppContainer.shared.userAuthService,
        userService: UserServiceProtocol = AppContainer.shared.userService,
        dietManager: DietManager = AppContainer.shared.dietManager,
        workoutManager: WorkoutManager = AppContainer.shared.workoutManager,
        userSessionManager: UserSessionManager = AppContainer.shared.userSessionManager,
        navigationManager: NavigationManager = AppContainer.shared.navigationManager
        
     ) {
        self.userAuthService = userAuthService
        self.userService = userService
        self.dietManager = dietManager
        self.workoutManager = workoutManager
        self.userSessionManager = userSessionManager
        self.navigationManager = navigationManager
    }
}

extension LoginViewModel {
    func updateEmail(_ value: String) {
        emailValue = value
    }

    func updatePassword(_ value: String) {
        passwordValue = value
    }

    func navigateToMainTabBarView() {
        let nav = UINavigationController(rootViewController: MainTabBarViewController())
        nav.isNavigationBarHidden = true
        navigationManager.setRootNav(nav)
    }

    func login() async {
        guard validateLogin() else { return }
        setState(.loading)
        defer { setState(.loaded) }
        do {
            let response = try await userAuthService.signIn(email: emailValue, password: passwordValue)
            print("Login response: \(response)")
            let user = try await userService.fetchUser(by: response.user.uid)
            print("Fetched user: \(user)")
            userSessionManager.updateSession(user)
            await loadDietManager()
            await loadWorkoutManager()
            navigateToMainTabBarView()
        } catch let error as UserAuthServiceError{
            errorMessage = error.userFriendlyMessage
            setState(.error(error.localizedDescription))
            print("Login error: \(error)")
        } catch {
            setState(.error(error.localizedDescription))
            print("Login error: \(error)")
            errorMessage = error.localizedDescription
        }
        
    }
    
    private func loadWorkoutManager() async {
        await workoutManager.loadManager()
    }
    
    private func loadDietManager() async {
        await dietManager.loadManager()
    }

    private func validateLogin() -> Bool {
        print("emailVlaue: \(emailValue), passwordValue: \(passwordValue)")
        guard !emailValue.isEmpty, !passwordValue.isEmpty
        else { return false }
        return true
    }
}
