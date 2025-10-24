//
//  SplashViewModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 17.10.2025.
//
import FirebaseAuth
import UIKit

final class SplashViewModel: BaseViewModel {
    private let userAuthService: UserAuthServiceProtocol
    private let userService: UserServiceProtocol
    private let healthKitManager: HealthKitManager
    private let dietManager: DietManager
    private let workoutManager: WorkoutManager
    
    init(
        userAuthService: UserAuthServiceProtocol = AppContainer.shared.userAuthService,
        userService: UserServiceProtocol = AppContainer.shared.userService,
        healthKitManager: HealthKitManager = AppContainer.shared.healthKitManager,
        dietManager: DietManager = AppContainer.shared.dietManager,
        workoutManager: WorkoutManager = AppContainer.shared.workoutManager
    ) {
        self.userAuthService = userAuthService
        self.userService = userService
        self.healthKitManager = healthKitManager
        self.dietManager = dietManager
        self.workoutManager = workoutManager
    }
    
    func checkUserAuthAndLoadData() async {
        setState(.loading)
        defer { setState(.loaded) }
        let isAuthorized = await checkUserAuth()
        if isAuthorized {
            await loadHealthData()
            await dietManager.loadManager()
            await workoutManager.loadManager()
            navigateToMainTabBarView()
        } else {
            navigateToLoginView()
        }
     }
        
    private func checkUserAuth() async -> Bool {
        guard let user = userAuthService.checkAuthUser() else {
            return false
        }
        let result = await fetchUserDetail(user.uid)
        return result
    }
    
    private func fetchUserDetail(_ uid: String) async -> Bool {
        do {
            let user = try await userService.fetchUser(by: uid)
            AppContainer.shared.userSessionManager.updateSession(user)
            return true
        } catch {
            print("Failed to fetch user data: \(error.localizedDescription)")
            return false
        }
    }
    
    private func navigateToMainTabBarView() {
        let nav = UINavigationController(rootViewController: MainTabBarViewController())
        nav.isNavigationBarHidden = true
        AppContainer.shared.navigationManager.setRootNav(nav)
    }
    
    private func navigateToLoginView() {
        let nav = UINavigationController(rootViewController: LoginViewController())
        AppContainer.shared.navigationManager.setRootNav(nav)
    }
    
    private func loadHealthData() async {
        await healthKitManager.authorizeAndFetchData()
    }
}
