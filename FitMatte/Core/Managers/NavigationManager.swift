//
//  NavigationManager.swift
//  FitMatte
//
//  Created by Emre Simsek on 14.10.2025.
//
import UIKit

final class NavigationManager {
    var nav: UINavigationController?
    private var window: UIWindow?

    func setInitialRoot(window: UIWindow?) {
        self.window = window
        guard let window = self.window else { return }
        window.makeKeyAndVisible()
    }

    func setRootNav(_ nav: UINavigationController) {
        guard let window else { return }
        UIView.transition(with: window,
                          duration: 0.5,
                          options: .curveEaseInOut,
                          animations: {
                              window.rootViewController = nav
                          }, completion: nil)
    }

    func push(_ vc: UIViewController, animated: Bool = true) {
        guard let nav else { return }
        nav.pushViewController(vc, animated: animated)
    }

    func present(_ vc: UIViewController, animated: Bool = true) {
        guard let nav else { return }
        nav.present(vc, animated: animated)
    }

    func pop(animated: Bool = true) {
        guard let nav else { return }
        nav.popViewController(animated: animated)
    }
}
