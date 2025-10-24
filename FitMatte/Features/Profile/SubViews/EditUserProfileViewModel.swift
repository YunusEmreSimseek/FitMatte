//
//  EditUserProfileViewModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 20.10.2025.
//
import Combine

final class EditUserProfileViewModel: BaseViewModel {
    private let userSessionManager: UserSessionManager
    @Published private(set) var currentUser: UserModel
    
    init(
        userSessionManager: UserSessionManager = AppContainer.shared.userSessionManager
    ) {
        self.userSessionManager = userSessionManager
        self.currentUser = userSessionManager.currentUser ?? UserModel.dummyUser
    }
    
}
