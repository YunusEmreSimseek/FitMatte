//
//  MainTabBarViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 14.10.2025.
//
import UIKit

final class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewNavigationControllers = MainTabs.allCases.map { $0.configureTab }
        setViewControllers(viewNavigationControllers, animated: true)
        
    }
}

#Preview {
    MainTabBarViewController()
}
