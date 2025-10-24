//
//  ProfileViewModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 14.10.2025.
//
import UIKit

final class ProfileViewModel: BaseViewModel {
    private let userAuthService: UserAuthServiceProtocol
    
    init(userAuthService: UserAuthServiceProtocol = AppContainer.shared.userAuthService) {
        self.userAuthService = userAuthService
    }
    
    func signOut() {
        let response = userAuthService.signOut()
        if response {
            AppContainer.shared.navigationManager.setRootNav(UINavigationController(rootViewController: LoginViewController()))
        }
        else {
            print("Sign out failed")
        }
    }
}
