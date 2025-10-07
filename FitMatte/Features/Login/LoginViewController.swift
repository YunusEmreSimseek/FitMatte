//
//  LoginViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 7.10.2025.
//
import UIKit

protocol LoginViewControllerProtocol: BaseViewControllerProtocol {}

final class LoginViewController: BaseViewController {
    init() { super.init(viewModel: LoginViewModel()) }
    
    override func configureVC() {
        view.backgroundColor = .red
    }
}

extension LoginViewController: LoginViewControllerProtocol {}

#Preview {
    LoginViewController()
}
