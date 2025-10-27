//
//  HomeViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 14.10.2025.
//
import UIKit
import DGCharts

final class HomeViewController: BaseViewController<HomeViewModel> {
    init() { super.init(viewModel: HomeViewModel()) }

    // MARK: - UI Components
    private var appNameLabel = LabelRow()
    private var motivationCard = ContainerRow()
    private var informationCards = StackRow()
    private var stepProgressCard = StackRow()
    private var aiCard = StackRow()
    private var dietProgressSummaryStack = StackRow()
    private var workoutSummaryStack = DataSectionRow<BaseTableCell<WorkoutSummaryStack>>()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup
    private func setup() {
        configureNavigationBar()
        configureAppNameLabel()
        configureMotivationCard()
        configureInformationCard()
        configureStepProgressCard()
        configureAICard()
        configureDietProgressSummaryStack()
        configureWorkoutSummaryStack()
        addSection([
            appNameLabel,
            motivationCard,
            informationCards,
            stepProgressCard,
            aiCard,
            dietProgressSummaryStack,
            workoutSummaryStack
        ])
    }
}

// MARK: - Component Configurations
extension HomeViewController {
    private func configureNavigationBar() {
        let notificationButton = UIBarButtonItem(image: UIImage(systemName: "bell"))
        let personButton = UIBarButtonItem(image: UIImage(systemName: "person"))
        let label1: UILabel = {
            let label = UILabel()
            label.text = LocaleKeys.Home.navBarTitle
            label.font = ThemeFont.defaultTheme.boldText
            return label
        }()
        let label2: UILabel = {
            let label = UILabel()
            label.text = viewModel.currentUser?.name ?? "Guest"
            label.font = ThemeFont.defaultTheme.semiBoldMediumText
            label.textColor = .systemBlue
            return label
        }()
        let stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [label1, label2])
            stackView.axis = .vertical
            stackView.spacing = 0
            stackView.alignment = .leading
            return stackView
        }()
        navigationItem.leftBarButtonItem = personButton
        navigationItem.titleView = stackView
        navigationItem.rightBarButtonItem = notificationButton
    }

    private func configureAppNameLabel() {
        appNameLabel.configureView { label in
            label.text = LocaleKeys.Common.appName
            label.font = ThemeFont.defaultTheme.highTitle
        }
    }

    private func configureMotivationCard() {
        let imageView: UIImageView = {
            let imageView = UIImageView(image: .motivation)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12
            imageView.translatesAutoresizingMaskIntoConstraints = false
//            imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
            return imageView
        }()
        let motivationLabel = BaseLabel("Discipline is doing it even when you don't feel like it.", ThemeFont.defaultTheme.boldText)
        motivationCard.configureView { view in
            view.addSubview(imageView)
            view.addSubview(motivationLabel)
            view.heightAnchor.constraint(equalToConstant: 250).isActive = true
            imageView.fillSuperview()
            motivationLabel.fillHorizontallySuperview(padding: 16)
            motivationLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16).isActive = true
        }
    }

    private func configureInformationCard() {
        let firstCard = createVStackCard("Steps", String(Int(viewModel.healthKitManager.stepCount)) + " steps")
        let secondCard = createVStackCard("Heart Rate", String(Int(viewModel.healthKitManager.averageHeartRate)) + " bpm")
        let thirdCard = createVStackCard("Sleep", String(Int(viewModel.healthKitManager.sleepHours)) + " hrs")
        let fourthCard = createVStackCard("Calories", String(Int(viewModel.healthKitManager.activeEnergyBurned)) + " kcal")
        let row1StackView = createRowStackView([firstCard, secondCard])
        let row2StackView = createRowStackView([thirdCard, fourthCard])
        informationCards.configureView { stack in
            stack.addArrangedSubview(row1StackView)
            stack.addArrangedSubview(row2StackView)
            stack.axis = .vertical
            stack.distribution = .fillEqually
            stack.spacing = 16
        }
    }

    private func configureStepProgressCard() {
        let titleLabel = BaseLabel("Step Progress", ThemeFont.defaultTheme.boldMediumText)
        let progressView: UIProgressView = {
            let progressView = UIProgressView(progressViewStyle: .bar)
            let progress = viewModel.healthKitManager.stepCount / Double(viewModel.currentUser?.stepGoal ?? 10000)
            progressView.progress = Float(progress)
            progressView.backgroundColor = .systemGray5
            progressView.heightAnchor.constraint(equalToConstant: 3).isActive = true
            return progressView
        }()
        let valueLabel: BaseLabel = {
            let label = BaseLabel("\(String(Int(viewModel.healthKitManager.stepCount))) / \(String(Int(viewModel.currentUser?.stepGoal ?? 10000))) steps")
            label.font = ThemeFont.defaultTheme.smallText
            label.textColor = .secondaryLabel
            return label
        }()

        stepProgressCard.configureView { stack in
            stack.axis = .vertical
            stack.spacing = 8
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(progressView)
            stack.addArrangedSubview(valueLabel)
            stack.toCard()
        }
    }

    private func configureAICard() {
        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "brain.head.profile")
            imageView.contentMode = .scaleAspectFill
            imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            return imageView
        }()
        let titleLabel = BaseLabel("Ask Your AI Coach", ThemeFont.defaultTheme.boldMediumText)
        let subTitleLabel: BaseLabel = {
            let label = BaseLabel("Need workout tips? Nutiriton advice? Just ask!")
            label.font = ThemeFont.defaultTheme.smallText
            label.textColor = .secondaryLabel
            return label
        }()
        let navigateButton: UIButton = {
            let button = UIButton(type: .system)
            var cfg = UIButton.Configuration.plain()
            cfg.image = UIImage(systemName: "chevron.right")
            cfg.preferredSymbolConfigurationForImage = .init(font: .systemFont(ofSize: 12))
            cfg.contentInsets = .zero
            button.configuration = cfg
            button.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            return button
        }()
        let vStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
            stack.axis = .vertical
            stack.spacing = 8
            stack.setContentHuggingPriority(.defaultLow, for: .horizontal)
            return stack
        }()
        aiCard.configureView { stack in
            stack.axis = .horizontal
            stack.spacing = 16
            stack.alignment = .center
            stack.addArrangedSubview(imageView)
            stack.addArrangedSubview(vStack)
            stack.addArrangedSubview(UIView())
            stack.addArrangedSubview(navigateButton)
            stack.toCard()
        }
        aiCard.configureCell { cell in
            cell.selectionStyle = .default
        }
        aiCard.configureDidSelect {
            guard let tabBarController = self.tabBarController else { return }
            tabBarController.selectedIndex = MainTabs.chat.rawValue
        }
    }

    private func configureDietProgressSummaryStack() {
        let titleLabel = BaseLabel("Progress Summary", ThemeFont.defaultTheme.boldText)

        let remainingDaysItem = createSummaryItem(imageName: "calendar", value: "\(viewModel.dietManager.remainingDays)", text: "Remaining Days")
        let caloriesConsumedItem = createSummaryItem(imageName: "flame.fill", value: "\(viewModel.dietManager.averageCalories) kcal", text: "Avg. Calories")
        let stepsTakenItem = createSummaryItem(imageName: "figure.walk.circle.fill", value: "\(viewModel.dietManager.averageSteps)", text: "Avg. Steps")

        let hStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [remainingDaysItem, caloriesConsumedItem, stepsTakenItem])
            stack.spacing = 16
            stack.distribution = .fillEqually
            return stack
        }()

        dietProgressSummaryStack.configureView { stack in
            stack.axis = .vertical
            stack.spacing = 32
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(hStack)
            stack.toCard()
        }
    }
        
    private func configureWorkoutSummaryStack() {
        workoutSummaryStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.setData(self.viewModel.workoutManager.workoutLogs)
        }
        
        
    }
        
}

// MARK: - Helper Methods
extension HomeViewController {
    private func createSummaryItem(imageName: String, value: String, text: String) -> UIStackView {
        let rowImage: UIImageView = {
            let imageView = UIImageView(image: .init(systemName: imageName))
            imageView.contentMode = .scaleAspectFit
            imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
            return imageView
        }()
        let rowValue = BaseLabel(value, ThemeFont.defaultTheme.mediumText)
        let rowText: BaseLabel = {
            let label = BaseLabel(text, ThemeFont.defaultTheme.smallText)
            label.textColor = .secondaryLabel
            return label
        }()
        let vStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [rowImage, rowValue, rowText])
            stack.axis = .vertical
            stack.spacing = 4
            stack.alignment = .center
            return stack
        }()
        return vStack
    }

    private func createRowStackView(_ items: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: items)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 32
        return stackView
    }

    private func createVStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }

    private func createVStackCard(_ title: String, _ subTitle: String) -> UIStackView {
        let stackView = createVStackView()
        let titleLabel: BaseLabel = {
            let label = BaseLabel(title)
            label.font = ThemeFont.defaultTheme.semiBoldMediumText
            label.textColor = .secondaryLabel
            return label
        }()
        let subtitleLabel: BaseLabel = {
            let label = BaseLabel(subTitle)
            label.font = ThemeFont.defaultTheme.boldMediumText
            return label
        }()
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stackView.card()
        return stackView
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
