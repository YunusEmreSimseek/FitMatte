//
//  SignUpViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 14.10.2025.
//
import Combine
import UIKit

final class SignUpViewController: BaseViewController<SignUpViewModel> {
    init() { super.init(viewModel: SignUpViewModel()) }
    
    private var appNameLabel = LabelRow()
    private var titleLabel = LabelRow()
    private var nameTextField = BaseTextFieldRow()
    private var emailTextField = BaseTextFieldRow()
    private var passwordTextField = BaseTextFieldRow()
    private var signUpButton = ButtonRow()
    private var bottomContainer = ContainerRow()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBackgroundImageConstraints()
        backgroundImageView.image = .aiCoach
    }
    
    private func setupUI() {
        configureAppNameLabel()
        configureTitleLabel()
        configureNameTextField()
        configureEmailTextField()
        configurePasswordTextField()
        configureSignUpButton()
        configureBottomContainer()
        addSection([
            appNameLabel,
            titleLabel,
            nameTextField,
            emailTextField,
            passwordTextField,
            signUpButton,
            bottomContainer
        ])
    }
}

extension SignUpViewController {
    private func configureAppNameLabel() {
        appNameLabel.configureView { label in
            label.text = LocaleKeys.Common.appName
            label.font = ThemeFont.defaultTheme.veryLargeTitle
            label.textAlignment = .center
        }
        appNameLabel.configureCell { cell in
            cell.topPadding(140)
        }
    }
    
    private func configureTitleLabel() {
        titleLabel.configureView { label in
            label.text = LocaleKeys.SignUp.title
            label.font = ThemeFont.defaultTheme.title
            label.textAlignment = .center
        }
        titleLabel.configureCell { cell in
            cell.bottomPadding(50)
        }
    }
    
    private func configureNameTextField() {
        nameTextField.configureView { textField in
            textField.placeholder = LocaleKeys.Common.nameAndSurname
            textField.textPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] newValue in
                    guard let self else { return }
                    self.viewModel.updateName(newValue)
                }
                .store(in: &self.cancellables)
        }
    }
    
    private func configureEmailTextField() {
        emailTextField.configureView { textField in
            textField.placeholder = LocaleKeys.Common.email
            textField.keyboardType = .emailAddress
            textField.textPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] newValue in
                    guard let self else { return }
                    self.viewModel.updateEmail(newValue)
                }
                .store(in: &self.cancellables)
        }
    }
    
    private func configurePasswordTextField() {
        passwordTextField.configureView { textField in
            textField.placeholder = LocaleKeys.Common.password
            textField.textPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] newValue in
                    guard let self else { return }
                    self.viewModel.updatePassword(newValue)
                }
                .store(in: &self.cancellables)
        }
    }
    
    private func configureSignUpButton() {
        signUpButton.configureView { button in
            button.setTitle(LocaleKeys.Button.signUp)
        }
        signUpButton.configureCell { cell in
            cell.verticalPadding(24)
        }
    }
    
    private func configureBottomContainer() {
        let signupLabel = BaseLabel(LocaleKeys.SignUp.loginTitle)
        let signUpButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle(LocaleKeys.Button.login, for: .normal)
            button.titleLabel?.font = ThemeFont.defaultTheme.boldText
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        bottomContainer.configureView { view in
            view.addSubview(signupLabel)
            view.addSubview(signUpButton)
            NSLayoutConstraint.activate([
                signupLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                signupLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                signUpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            ])
        }
     }
}

extension SignUpViewController: BackgroundImageProvider {}

#Preview {
    SignUpViewController()
}
