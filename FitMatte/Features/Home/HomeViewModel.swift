//
//  HomeViewModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 14.10.2025.
//

final class HomeViewModel: BaseViewModel {
    private let userSessionManager: UserSessionManager
    let dietManager: DietManager
    let healthKitManager: HealthKitManager
    var currentUser: UserModel? {
        return userSessionManager.currentUser
    }

    init(
        userSessionManager: UserSessionManager = AppContainer.shared.userSessionManager,
        healthKitManager: HealthKitManager = AppContainer.shared.healthKitManager,
        dietManager: DietManager = AppContainer.shared.dietManager
    ) {
        self.userSessionManager = userSessionManager
        self.healthKitManager = healthKitManager
        self.dietManager = dietManager
    }
}
