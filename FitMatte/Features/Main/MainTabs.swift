//
//  MainTabs.swift
//  FitMatte
//
//  Created by Emre Simsek on 14.10.2025.
//
import UIKit

enum MainTabs: Int, CaseIterable {
    case home
    case chat
    case track
    case profile
    
    
    

    var configureTab: UINavigationController {
        let nc = UINavigationController(rootViewController: self.viewController)
        nc.tabBarItem.image = self.icon
        nc.tabBarItem.title = self.title
        return nc
    }

    private var viewController: UIViewController {
        switch self {
        case .home:
            HomeViewController()
        case .chat:
            ChatViewController()
        case .track:
            TrackViewController()
        case .profile:
            ProfileViewController()
        }
    }

    private var icon: UIImage? {
        switch self {
        case .home:
            UIImage(systemName: "house")
        case .chat:
            UIImage(systemName: "message")
        case .track:
            UIImage(systemName: "chart.bar")
        case .profile:
            UIImage(systemName: "person")
        }
    }

    private var title: String {
        switch self {
        case .home:
            LocaleKeys.Tabs.home
        case .chat:
            LocaleKeys.Tabs.chat
        case .track:
            LocaleKeys.Tabs.track
        case .profile:
            LocaleKeys.Tabs.profile
        }
    }
}
