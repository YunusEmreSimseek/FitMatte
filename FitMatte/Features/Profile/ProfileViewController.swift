//
//  ProfileViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 14.10.2025.
//
import UIKit

final class ProfileViewController: BaseViewController<ProfileViewModel> {
    init() { super.init(viewModel: ProfileViewModel()) }

    // MARK: Properties
    // General Section
    private var settingsRow = ContainerRow()
    private var aiCreditsRow = ContainerRow()
    private var notificationsRow = ContainerRow()
    private var languageRow = ContainerRow()
    private var unitsRow = ContainerRow()
    // Support Us Section
    private var shareRow = ContainerRow()
    private var rateRow = ContainerRow()
    private var tipRow = ContainerRow()
    // Others Section
    private var appnameRow = ContainerRow()
    private var versionRow = ContainerRow()
    private var privacyRow = ContainerRow()
    private var signOutRow = ContainerRow()

    // MARK: Lifecycle
    override func viewDidLoad() {
        title = "Profile"
        super.viewDidLoad()
        changeTableStyle(.insetGrouped)
        changeTableSeparatorStyle(.singleLine)
        setup()
    }

    // MARK: Setup
    private func setup() {
        configureSettingsRow()
        configureAICreditsRow()
        configureNotificationsRow()
        configureLanguageRow()
        configureUnitsRow()
        configureShareRow()
        configureRateRow()
        configureTipRow()
        configureAppNameRow()
        configureVersionRow()
        configurePrivacyRow()
        configureSignOutRow()
        addSection([
            settingsRow,
            aiCreditsRow,
            notificationsRow,
            languageRow,
            unitsRow
        ])
        addSection([
            shareRow,
            rateRow,
            tipRow
        ])
        addSection([
            appnameRow,
            versionRow,
            privacyRow,
            signOutRow
        ])
    }
}

// MARK: Components Configuration
extension ProfileViewController {
    private func configureAppNameRow() {
        let appNameItem = SectionRowItem(icon: "dumbbell", title: "App Name", value: "FitMate", showLink: false)
        appnameRow.configureView { view in
            view.addSubview(appNameItem)
            appNameItem.fillSuperview()
        }
        appnameRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
        }
    }

    private func configureVersionRow() {
        let versionItem = SectionRowItem(icon: "info.circle", title: "Version", value: "1.0.0", showLink: false)
        versionRow.configureView { view in
            view.addSubview(versionItem)
            versionItem.fillSuperview()
        }
        versionRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
        }
    }

    private func configurePrivacyRow() {
        let privacyItem = SectionRowItem(icon: "lock.shield", title: "Privacy Policy")
        privacyRow.configureView { view in
            view.addSubview(privacyItem)
            privacyItem.fillSuperview()
        }
        privacyRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
        }
    }

    private func configureSignOutRow() {
        let signOutItem = SectionRowItem(icon: "arrow.right.square", title: "Sign Out")
        signOutRow.configureView { view in
            view.addSubview(signOutItem)
            signOutItem.fillSuperview()
        }
        signOutRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
        }
        
        signOutRow.configureDidSelect {
            let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self] _ in
                guard let self else { return }
                self.viewModel.signOut()
            }))
            self.present(alert, animated: true)
        }
    }

    private func configureShareRow() {
        let shareItem = SectionRowItem(icon: "square.and.arrow.up", title: "Share")
        shareRow.configureView { view in
            view.addSubview(shareItem)
            shareItem.fillSuperview()
        }
        shareRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
        }
    }

    private func configureRateRow() {
        let rateItem = SectionRowItem(icon: "star", title: "Rate on Store")
        rateRow.configureView { view in
            view.addSubview(rateItem)
            rateItem.fillSuperview()
        }
        rateRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
        }
    }

    private func configureTipRow() {
        let tipItem = SectionRowItem(icon: "gift", title: "Tip jar")
        tipRow.configureView { view in
            view.addSubview(tipItem)
            tipItem.fillSuperview()
        }
        tipRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
        }
    }

    private func configureSettingsRow() {
        let settingsItem = SectionRowItem(icon: "person", title: "Settings")
        settingsRow.configureView { view in
            view.addSubview(settingsItem)
            settingsItem.fillSuperview()
        }
        settingsRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
        }
        settingsRow.configureDidSelect {
            self.navigationController?.present(EditUserProfileViewController(), animated: true)
        }
    }

    private func configureAICreditsRow() {
        let aiCreditsItem = SectionRowItem(icon: "sparkles", title: "AI Credits", value: "100")
        aiCreditsRow.configureView { view in
            view.addSubview(aiCreditsItem)
            aiCreditsItem.fillSuperview()
        }
        aiCreditsRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
        }
    }

    private func configureNotificationsRow() {
        let notificaitonItem = SectionRowItem(icon: "bell", title: "Notifications")
        notificationsRow.configureView { view in
            view.addSubview(notificaitonItem)
            notificaitonItem.fillSuperview()
        }
        notificationsRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
        }
    }

    private func configureLanguageRow() {
        let languageItem = SectionRowItem(icon: "globe", title: "Language")
        languageRow.configureView { view in
            view.addSubview(languageItem)
            languageItem.fillSuperview()
        }
        languageRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
        }
    }

    private func configureUnitsRow() {
        let unitsItem = SectionRowItem(icon: "scalemass", title: "Units")
        unitsRow.configureView { view in
            view.addSubview(unitsItem)
            unitsItem.fillSuperview()
        }
        unitsRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
        }
    }
}

// MARK: Preview
#Preview {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .systemBackground
    appearance.configureWithOpaqueBackground()
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().standardAppearance = appearance
    return MainTabBarViewController()
}
