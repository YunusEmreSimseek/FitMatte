//
//  LoginViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 7.10.2025.
//
import Combine
import UIKit

final class LoginViewController: BaseViewController<LoginViewModel> {
    
    var appNameLabel = BaseRow<LabelCell>()
    var titleLabel = BaseRow<LabelCell>()
    var emailTextField = BaseRow<TextFieldCell>()
    var passwordTextField = BaseRow<TextFieldCell>()
    var loginButton = BaseRow<ButtonCell>()
    
    init() { super.init(viewModel: LoginViewModel())  }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        setupAppNameLabel()
        setupTitleLabel()
        setupEmailTextField()
        setupPasswordTextField()
        setupLoginButton()
        let section = BaseSection([
            appNameLabel, titleLabel, emailTextField, passwordTextField, loginButton
        ])
        setupUI([section])
    }
}

extension LoginViewController {
    private func setupAppNameLabel(){
        appNameLabel.configure = {[weak self] cell in
            guard let self else { return }
            let label = cell.view
            label.text = "FitMatte Email: \(self.viewModel.emailValue)"
            label.font = .boldSystemFont(ofSize: 24)
            label.textAlignment = .center
        }}
    private func setupTitleLabel(){
        titleLabel.configure = {[weak self] cell in
            guard let self else { return }
            let label = cell.view
            label.text = "Welcome Back! Password: \(self.viewModel.passwordValue)"
            label.font = .systemFont(ofSize: 20)
            label.textAlignment = .center
        }}
    private func setupEmailTextField(){
        emailTextField.configure = {[weak self] cell in
            guard let self else { return }
            let textField = cell.view
            textField.placeholder = "Email"
            textField.borderStyle = .roundedRect
            textField.autocapitalizationType = .none
            textField.keyboardType = .emailAddress
            textField.returnKeyType = .next
            textField.backgroundColor = .placeholderText
            textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
            textField.textPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] text in
                    guard let self else { return }
                    self.viewModel.updateEmail(text)}
                .store(in: &cancellables)
                    
        }
    }
    private func setupPasswordTextField(){
        passwordTextField.configure = {[weak self] cell in
            guard let self else { return }
            let textField = cell.view
            textField.placeholder = "Password"
            textField.borderStyle = .roundedRect
            textField.isSecureTextEntry = true
            textField.returnKeyType = .done
            textField.backgroundColor = .placeholderText
            textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
            textField.textPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] text in
                    guard let self else { return }
                    self.viewModel.updatePassword(text)}
                .store(in: &cancellables)
        }
    }
    private func setupLoginButton(){
        loginButton.configure = {[weak self] cell in
            guard let self else { return }
            let button = cell.view
            var cfg = UIButton.Configuration.filled()
            cfg.title = "Login"
            cfg.baseBackgroundColor = .systemBlue
            cfg.baseForegroundColor = .white
            cfg.background.cornerRadius = 8
            button.configuration = cfg
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            button.removeTarget(nil, action: nil, for: .allEvents)
            button.addAction(UIAction{[weak self] _ in
                guard let self else { return }
                self.viewModel.counter += 1
                self.setup()
            }, for: .touchUpInside)
            
            
        }
        
    }
}

#Preview { LoginViewController() }
