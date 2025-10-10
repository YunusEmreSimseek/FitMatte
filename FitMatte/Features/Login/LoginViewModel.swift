//
//  LoginViewModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 7.10.2025.
//
import Combine
import Foundation


final class LoginViewModel: BaseViewModel {
    @Published private(set) var emailValue = ""
    @Published private(set) var passwordValue = ""
    var counter = 0
    @Published private(set) var isLoginEnabled = false
    @Published private(set) var errorMessage: String?
}

extension LoginViewModel {
    func updateEmail(_ value: String) {
        emailValue = value
    }

    func updatePassword(_ value: String) {
        passwordValue = value
    }

    func test() async {
        setState(.loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.counter += 1
            print("counter: \(self.counter)")
            let isValidate = self.validateLogin()
            if isValidate {
                self.errorMessage = nil
            } else {
                self.errorMessage = "Please enter valid email and password."
            }
            self.setState(.loaded)
        }
    }

    private func validateLogin() -> Bool {
        print("emailVlaue: \(emailValue), passwordValue: \(passwordValue)")
        guard !emailValue.isEmpty, !passwordValue.isEmpty
        else { return false }
        return true
    }
}
