//
//  LoginViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 7.10.2025.
//
import UIKit

final class LoginViewController: BaseViewController<LoginViewModel> {
    init() { super.init(viewModel: LoginViewModel()) }
    private var viewItems: [UIView] { [] }

    override func configureVC() {}

    override func configureSubViews() {}

    override func addSubViews() {
        guard !viewItems.isEmpty else { return }
        for item in viewItems {
            view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    override func configureConstraints() {
        NSLayoutConstraint.activate([
        ])
    }
}

extension LoginViewController {}

#Preview {
    LoginViewController()
}
