//
//  SignUpViewModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 14.10.2025.
//
import Combine

final class SignUpViewModel: BaseViewModel {
    @Published private(set) var emailValue = ""
    @Published private(set) var passwordValue = ""
    @Published private(set) var nameValue = ""
    
}

extension SignUpViewModel {
    func updateEmail(_ value: String) {
        emailValue = value
    }
    
    func updatePassword(_ value: String) {
        passwordValue = value
    }
    
    func updateName(_ value: String) {
        nameValue = value
    }
    
}
