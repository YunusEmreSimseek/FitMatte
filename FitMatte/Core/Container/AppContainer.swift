//
//  AppContainer.swift
//  FitMatte
//
//  Created by Emre Simsek on 17.10.2025.
//
import Swinject

final class AppContainer {
    static let shared = AppContainer()
    private let container: Container
    private init() {
        container = Container()
        registerDependencies()
    }
    
    // MARK: - Managers
    var navigationManager: NavigationManager {
        guard let instance = container.resolve(NavigationManager.self) else {
            fatalError("NavigationManager dependency could not be resolved")
        }
        return instance
    }
    
    var userSessionManager: UserSessionManager {
        guard let instance = container.resolve(UserSessionManager.self) else {
            fatalError("UserSessionManager dependency could not be resolved")
        }
        return instance
    }
    
    var healthKitManager: HealthKitManager {
        guard let instance = container.resolve(HealthKitManager.self) else {
            fatalError("HealthKitManager dependency could not be resolved")
        }
        return instance
    }
    
    var dietManager: DietManager {
        guard let instance = container.resolve(DietManager.self) else {
            fatalError("DietManager dependency could not be resolved")
        }
        return instance
    }
    
    var workoutManager: WorkoutManager {
        guard let instance = container.resolve(WorkoutManager.self) else {
            fatalError("WorkoutManager dependency could not be resolved")
        }
        return instance
    }
    
    // MARK: - Services
    var userAuthService: UserAuthServiceProtocol {
        guard let instance = container.resolve(UserAuthServiceProtocol.self) else {
            fatalError("UserAuthService dependency could not be resolved")
        }
        return instance
    }

    var userService: UserServiceProtocol {
        guard let instance = container.resolve(UserServiceProtocol.self) else {
            fatalError("UserService dependency could not be resolved")
        }
        return instance
    }
    
    var chatService: ChatServiceProtocol {
        guard let instance = container.resolve(ChatServiceProtocol.self) else {
            fatalError("ChatService dependency could not be resolved")
        }
        return instance
    }
    
    var workoutService: WorkoutServiceProtocol {
        guard let instance = container.resolve(WorkoutServiceProtocol.self) else {
            fatalError("WorkoutService dependency could not be resolved")
        }
        return instance
    }
    
    var dietService: DietServiceProtocol {
        guard let instance = container.resolve(DietServiceProtocol.self) else {
            fatalError("DietService dependency could not be resolved")
        }
        return instance
    }
    
    // MARK: - Registration
    func registerDependencies() {
        // MARK: - Services
        container.register(UserAuthServiceProtocol.self) { _ in
            UserAuthService()
        }.inObjectScope(.container)
        
        container.register(UserServiceProtocol.self) { _ in
            UserService()
        }.inObjectScope(.container)
        
        container.register(ChatServiceProtocol.self) { _ in
            ChatService()
        }.inObjectScope(.container)
        
        container.register(WorkoutServiceProtocol.self) { _ in
            WorkoutService()
        }.inObjectScope(.container)
        
        container.register(DietServiceProtocol.self) { _ in
            DietService()
        }.inObjectScope(.container)
        
        // MARK: - Managers
        container.register(UserSessionManager.self) { _ in
            UserSessionManager()
        }.inObjectScope(.container)
        
        container.register(NavigationManager.self) { _ in
            NavigationManager()
        }.inObjectScope(.container)
        
        container.register(HealthKitManager.self) { _ in
            HealthKitManager()
        }.inObjectScope(.container)
        
        container.register(DietManager.self) { _ in
            DietManager()
        }.inObjectScope(.container)
        
        container.register(WorkoutManager.self) { _ in
            WorkoutManager()
        }.inObjectScope(.container)
    }
}
