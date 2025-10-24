//
//  LoginViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 7.10.2025.
//
import Combine
import UIKit

final class LoginViewController: BaseViewController<LoginViewModel> {
    init() { super.init(viewModel: LoginViewModel()) }

    // MARK: - UI Components
    private var appNameLabel = LabelRow()
    private var titleLabel = LabelRow()
    private var emailTextField = BaseTextFieldRow()
    private var passwordTextField = BaseTextFieldRow()
    private var loginButton = ButtonRow()
    private var bottomContainer = ContainerRow()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBackgroundImageConstraints()
        backgroundImageView.image = .aiCoach
    }

    // MARK: - Setup
    private func setup() {
        setupAppNameLabel()
        setupTitleLabel()
        setupEmailTextField()
        setupPasswordTextField()
        setupLoginButton()
        setupStackRow()
        setupBottomContainer()
        addSection([
            appNameLabel, titleLabel,
            emailTextField, passwordTextField,
            loginButton,
            bottomContainer
        ])
//        let section = BaseSection([
//            appNameLabel, titleLabel,
//            emailTextField, passwordTextField,
//            loginButton,
//            bottomContainer
//
//        ])
//        setupUI([section])
    }
}

// MARK: - Component Configurations
extension LoginViewController {
    private func setupAppNameLabel() {
        appNameLabel.configureView { label in
            label.text = LocaleKeys.Common.appName
            label.font = ThemeFont.defaultTheme.veryLargeTitle
            label.textAlignment = .center
        }
        appNameLabel.configureCell { cell in
            cell.topPadding(140)
        }
    }

    private func setupTitleLabel() {
        titleLabel.configureView { label in
            label.text = LocaleKeys.Login.title
            label.font = ThemeFont.defaultTheme.title
            label.textAlignment = .center
        }
        titleLabel.configureCell { cell in
            cell.bottomPadding(50)
        }
    }

    private func setupEmailTextField() {
        emailTextField.configureView { textField in
            textField.placeholder = LocaleKeys.Common.email
            textField.keyboardType = .emailAddress
            textField.textContentType = .emailAddress
            textField.autocapitalizationType = .none
            textField.textPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] newValue in
                    guard let self else { return }
                    self.viewModel.updateEmail(newValue)
                }
                .store(in: &self.cancellables)
        }
    }

    private func setupPasswordTextField() {
        passwordTextField.configureView { textField in
            textField.placeholder = LocaleKeys.Common.password
            textField.isSecureTextEntry = true
            textField.textPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] newValue in
                    guard let self else { return }
                    self.viewModel.updatePassword(newValue)
                }
                .store(in: &self.cancellables)
        }
    }

    private func setupLoginButton() {
        loginButton.configureView { button in
            button.setTitle(LocaleKeys.Button.login)
            button.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                Task { await self.viewModel.login() }
//                self.viewModel.navigateToMainTabBarView()
            }, for: .touchUpInside)
        }
        loginButton.configureCell { cell in
            cell.verticalPadding(24)
        }
    }

    private func setupStackRow() {}

    private func setupBottomContainer() {
        let signupLabel: BaseLabel = {
            let label = BaseLabel(LocaleKeys.Login.signUpTitle)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        let signUpButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle(LocaleKeys.Button.signUp, for: .normal)
            button.titleLabel?.font = ThemeFont.defaultTheme.semiBoldText
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

// MARK: - BackgroundImageProvider
extension LoginViewController: BackgroundImageProvider {}

// MARK: - Preview
#Preview {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .systemBackground
    appearance.configureWithOpaqueBackground()
    UINavigationBar.appearance().scrollEdgeAppearance = appearance

    UINavigationBar.appearance().standardAppearance.configureWithOpaqueBackground()
    return UINavigationController(rootViewController: LoginViewController())
}
