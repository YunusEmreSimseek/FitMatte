//
//  DietViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 21.10.2025.
//
import UIKit
import Combine

final class DietViewController: BaseViewController<DietViewModel> {
    init() { super.init(viewModel: DietViewModel()) }

    // MARK: - UI Components
    private var dietProcessHeaderStack = StackRow()
    private var dietProcessBodyStack = StackRow()
    private var dietProgressSummaryStack = StackRow()
    private var dailyDietLogs: [StackRow] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTableStyle(.insetGrouped)
        changeTableSeparatorStyle(.singleLine)
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        configureDietProcessHeaderStack()
        configureDietProcessBodyStack()
        configureDietProgressSummaryStack()
        configureDailyDietLogs()
        addSection([dietProcessHeaderStack, dietProcessBodyStack])
        addSection([dietProgressSummaryStack])
        addSection(dailyDietLogs, title: "Daily Logs")
        viewModel.dietManager.$dietPlan
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                guard let self else { return }
                self.reload()
                print("Diet View Controller Reloaded due to Diet Plan Change")
            }
            .store(in: &cancellables)
        viewModel.dietManager.$dailyLogs
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                guard let self else { return }
                self.reload()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Reload
    private func reload(){
        cleanTable()
        dietProcessHeaderStack = .init()
        dietProcessBodyStack = .init()
        dietProgressSummaryStack = .init()
        dailyDietLogs = []
        setup()
    }
}

// MARK: - Component Configurations
extension DietViewController {
    private func configureDietProcessHeaderStack() {
        let dietProcessTitle = createHeaderStack(title: "Diet Process", value: "\(viewModel.dietManager.dietPlan?.durationInDays ?? 0) Days Plan")
        let remainingDaysTitle = createHeaderStack(title: "Remaining Days", value: "\(viewModel.dietManager.remainingDays) Days")
        dietProcessHeaderStack.configureView { stack in
            stack.addArrangedSubview(dietProcessTitle)
            stack.addArrangedSubview(remainingDaysTitle)
        }
        dietProcessHeaderStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
            cell.topPadding(16)
            cell.bottomPadding(32)
        }
    }

    private func configureDietProcessBodyStack() {
        let weightRow = createDietGoalRow(imageName: "scalemass", text: "Weight Goal: \(viewModel.dietManager.dietPlan?.targetWeight ?? 0) kg")
        let calorieRow = createDietGoalRow(imageName: "flame", text: "Calorie Limit: \(viewModel.dietManager.dietPlan?.dailyCalorieLimit ?? 0) kcal")
        let stepsRow = createDietGoalRow(imageName: "figure.walk", text: "Daily Steps Goal: \(viewModel.dietManager.dietPlan?.dailyStepGoal ?? 0) steps")
        let proteinRow = createDietGoalRow(imageName: "leaf", text: "Protein Intake: \(viewModel.dietManager.dietPlan?.dailyProteinGoal ?? 0) g")
        dietProcessBodyStack.configureView { stack in
            stack.axis = .vertical
            stack.spacing = 16
            stack.addArrangedSubview(weightRow)
            stack.addArrangedSubview(calorieRow)
            stack.addArrangedSubview(stepsRow)
            stack.addArrangedSubview(proteinRow)
        }
        dietProcessBodyStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
            cell.bottomPadding(16)
            cell.topPadding(32)
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
        }
        dietProgressSummaryStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.allPadding(16)
        }
    }
    
    private func configureDailyDietLogs(){
        for dailyLog in viewModel.dietManager.dailyLogs {
            var logRow = StackRow()
            let dateLabel = BaseLabel("  \(dailyLog.dateString)", ThemeFont.defaultTheme.mediumText)
            let stepsImage: UIImageView = {
                let imageView = UIImageView(image: .init(systemName: "figure.walk"))
                imageView.contentMode = .scaleAspectFit
                imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
                return imageView
            }()
            let stepsLabel = BaseLabel("\(dailyLog.stepCount ?? 0) steps", ThemeFont.defaultTheme.smallText)
            let stepsStack: UIStackView = {
                let stack = UIStackView(arrangedSubviews: [stepsImage, stepsLabel])
                stack.spacing = 4
                return stack
            }()
            let calorieImage: UIImageView = {
                let imageView = UIImageView(image: .init(systemName: "flame.fill"))
                imageView.contentMode = .scaleAspectFit
                imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
                return imageView
            }()
            let calorieLabel = BaseLabel("\(dailyLog.caloriesTaken ?? 0) kcal", ThemeFont.defaultTheme.smallText)
            let calorieStack: UIStackView = {
                let stack = UIStackView(arrangedSubviews: [calorieImage, calorieLabel])
                stack.spacing = 4
                return stack
            }()
            let hStack: UIStackView = {
                let stack = UIStackView(arrangedSubviews: [stepsStack, calorieStack])
                stack.spacing = 8
                return stack
            }()
            let vStack: UIStackView = {
                let stack = UIStackView(arrangedSubviews: [dateLabel, hStack])
                stack.axis = .vertical
                stack.spacing = 8
                return stack
            }()
            logRow.configureView { stack in
                stack.addArrangedSubview(vStack)
                stack.addArrangedSubview(UIView())
                stack.addArrangedSubview(LinkButton(.small))
            }
            logRow.configureCell { cell in
                cell.backgroundColor = .secondarySystemGroupedBackground
                cell.horizontalPadding(16)
                cell.verticalPadding(12)
                cell.selectionStyle = .default
            }
            
            logRow.configureDidSelect {
                guard let navigationController = self.navigationController else { return }
                navigationController.present(DietLogDetailsViewController(dietLog: dailyLog), animated: true)
            }
            
            logRow.addContextMenuAction(UIAction(title: "Delete", image: .init(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                guard let self else { return }
                let alert = UIAlertController(
                    title: "Delete Log",
                    message: "Are you sure you want to delete this diet log? This action cannot be undone.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                    guard let self else { return }
                    Task {
                        await self.viewModel.deleteDailyDietLog(dailyLog)
                        self.reload()
                    }
                    
                    
                    
                })
                self.present(alert, animated: true)
            })
            dailyDietLogs.append(logRow)
        }
    }
}

// MARK: - Helper Methods
extension DietViewController {
    private func createHeaderStack(title: String, value: String) -> UIStackView {
        let titleLabel: BaseLabel = {
            let label = BaseLabel(title, ThemeFont.defaultTheme.mediumText)
            label.textColor = .secondaryLabel
            return label
        }()

        let titleValue = BaseLabel(value, ThemeFont.defaultTheme.boldText)
        let titleStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [titleLabel, titleValue])
            stack.axis = .vertical
            stack.spacing = 8
            stack.alignment = .leading
            return stack
        }()
        return titleStack
    }

    private func createDietGoalRow(imageName: String, text: String) -> UIStackView {
        let rowImage: UIImageView = {
            let imageView = UIImageView(image: .init(systemName: imageName))
            imageView.contentMode = .scaleAspectFit
            imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            return imageView
        }()
        let rowItem = BaseLabel(text, ThemeFont.defaultTheme.mediumText)
        let row: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [rowImage, rowItem])
            stack.spacing = 16
            return stack
        }()
        return row
    }

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
    
    private func createDailyLogItem(){
        
    }
}

// MARK: - Preview
#Preview {
    UINavigationController(rootViewController: DietViewController())
}
