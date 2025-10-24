//
//  TrackViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 14.10.2025.
//
import Charts
import UIKit

final class TrackViewController: BaseViewController<TrackViewModel> {
    init() { super.init(viewModel: TrackViewModel()) }

    // MARK: - UI Components
    private var currentVC: UIViewController = WorkoutViewController()
    private let navBarMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.init(systemName: "plus"), for: .normal)
        button.showsMenuAsPrimaryAction = true
        return button
    }()


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup
    private func setup() {
        configureNavigationBar()
        configureCurrentPage()
    }
    
    // MARK: - Reload
    private func reload() {
        configureCurrentPage()
    }
}

// MARK: - Component Configurations
extension TrackViewController {
    private func configureNavigationBar() {
        let menuActions = viewModel.currentPage.addButtonMenuItems.map { menuItem in
            UIAction(title: menuItem.rawValue) { [weak self] _ in
                guard let self else { return }
                guard let navigationController = self.navigationController else { return }
                navigationController.present(menuItem.target, animated: true)
            }
        }
        let menu = UIMenu(children: menuActions)
        navBarMenuButton.menu = menu

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navBarMenuButton)
        let titleSegment: UISegmentedControl = {
            let segmentedControl = UISegmentedControl(items: TrackViewTab.allCases.map { $0.title })
            segmentedControl.selectedSegmentIndex = viewModel.currentPage.rawValue
            segmentedControl.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                self.viewModel.updateCurrentPage(segmentedControl)
                self.configureCurrentPage()
            }, for: .valueChanged)
            return segmentedControl
        }()
        navigationItem.titleView = titleSegment
    }

    private func configureCurrentPage() {
        let outgoingVC = currentVC
        let incomingVC: UIViewController
        incomingVC = viewModel.currentPage.viewController
        let menuActions = viewModel.currentPage.addButtonMenuItems.map { menuItem in
            UIAction(title: menuItem.rawValue) { [weak self] _ in
                guard let self else { return }
                guard let navigationController = self.navigationController else { return }
                navigationController.present(menuItem.target, animated: true)
            }
        }
        let menu = UIMenu(children: menuActions)
        navBarMenuButton.menu = menu
        guard outgoingVC != incomingVC else { return }
        outgoingVC.willMove(toParent: nil)
        addChild(incomingVC)
        if let outgoingView = outgoingVC.view {
            outgoingView.removeFromSuperview()
        }
        view.addSubview(incomingVC.view)
        incomingVC.view.fillSuperview()
        incomingVC.didMove(toParent: self)
        currentVC = incomingVC
    }
}

// MARK: - Preview
#Preview {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .systemBackground
    appearance.configureWithOpaqueBackground()
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().standardAppearance = appearance
    return MainTabBarViewController()
}
