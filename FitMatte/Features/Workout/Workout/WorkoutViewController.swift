//
//  WorkoutViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 21.10.2025.
//
import UIKit
import Combine
final class WorkoutViewController: BaseViewController<WorkoutViewModel> {
    init() { super.init(viewModel: WorkoutViewModel()) }

    // MARK: - UI Components
    private var workoutSummaryStatsRow = StackRow()
    private var workoutSummaryChartRow = ContainerRow()
    private var workoutProgramRows: [StackRow] = []
    private var workoutHistoryRows: [StackRow] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTableStyle(.insetGrouped)
        changeTableSeparatorStyle(.singleLine)
        setup()
        viewModel.workoutManager.$workoutPrograms
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                guard let self else { return }
                self.reload()
                
            }
            .store(in: &cancellables)
        viewModel.workoutManager.$workoutLogs
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                guard let self else { return }
                self.reload()
                
            }
            .store(in: &cancellables)
    }

    // MARK: - Setup
    private func setup() {
        configureWorkoutProgramRows()
        configureWorkoutHistoryRows()
        configureWorkoutSummaryStatsRow()
        configureWorkoutSummaryChartRow()
        addSection([
            workoutSummaryStatsRow,
            workoutSummaryChartRow
        ], title: "Workout Summary")
        addSection(workoutProgramRows, title: "Workout Programs")
        addSection(workoutHistoryRows, title: "Workout History")
    }
    
    // MARK: - Reload
    private func reload() {
        cleanTable()
        workoutSummaryStatsRow = .init()
        workoutSummaryChartRow = .init()
        workoutProgramRows = []
        workoutHistoryRows = []
        setup()
        print("WorkoutViewController reloaded")
    }
}

// MARK: - Component Configurations
extension WorkoutViewController {
    private func configureWorkoutSummaryStatsRow() {
        let totalTrainingLabel: BaseLabel = {
            let label = BaseLabel("Total Trainings:")
            label.font = ThemeFont.defaultTheme.semiBoldMediumText
            label.textColor = .secondaryLabel
            return label
        }()
        let totalTrainingValueLabel = BaseLabel("9")
        let totalTrainingStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [totalTrainingLabel, totalTrainingValueLabel])
            stack.axis = .vertical
            stack.spacing = 8
            stack.alignment = .center
            return stack
        }()
        let weeklyAverageLabel: BaseLabel = {
            let label = BaseLabel("Weekly Average:")
            label.font = ThemeFont.defaultTheme.semiBoldMediumText
            label.textColor = .secondaryLabel
            return label
        }()
        let weeklyAverageValueLabel = BaseLabel("0.75")
        let weeklyAverageStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [weeklyAverageLabel, weeklyAverageValueLabel])
            stack.axis = .vertical
            stack.spacing = 8
            stack.alignment = .center
            return stack
        }()
        workoutSummaryStatsRow.configureView { stack in
            stack.addArrangedSubview(totalTrainingStack)
            stack.addArrangedSubview(weeklyAverageStack)
        }
        workoutSummaryStatsRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
        }
    }

    private func configureWorkoutSummaryChartRow() {}

    private func configureWorkoutProgramRows() {
        for program in viewModel.workoutManager.workoutPrograms {
            let titleLabel = BaseLabel(program.name, ThemeFont.defaultTheme.text)
            let linkButton = LinkButton(.small)
            var workoutProgram = StackRow()
            workoutProgram.configureView { stack in
                stack.addArrangedSubview(titleLabel)
                stack.addArrangedSubview(UIView())
                stack.addArrangedSubview(linkButton)
            }
            workoutProgram.configureCell { cell in
                cell.backgroundColor = .secondarySystemGroupedBackground
                cell.allPadding(16)
                cell.selectionStyle = .default
            }
            
            workoutProgramRows.append(workoutProgram)
        }
    }

    private func configureWorkoutHistoryRows() {
        for workoutLog in viewModel.workoutManager.workoutLogs {
            let titleLabel: BaseLabel = {
                let label = BaseLabel(workoutLog.date.formatted(date: .abbreviated, time: .omitted))
                label.font = ThemeFont.defaultTheme.semiBoldMediumText
                return label
            }()
            let subTitleLabel: BaseLabel = {
                let label = BaseLabel(workoutLog.programName ?? "Unknown Program")
                label.font = ThemeFont.defaultTheme.smallText
                label.textColor = .secondaryLabel
                return label
            }()
            let detailLabel: BaseLabel = {
                let label = BaseLabel(workoutLog.dayName ?? "Unknown Day")
                label.font = ThemeFont.defaultTheme.smallText
                label.textColor = .secondaryLabel
                return label
            }()
            let workoutVStack: UIStackView = {
                let stack = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel, detailLabel])
                stack.axis = .vertical
                stack.spacing = 4
                return stack
            }()
            let linkButton = LinkButton(.small)
            var workoutHistory = StackRow()
            workoutHistory.configureView { stack in
                stack.addArrangedSubview(workoutVStack)
                stack.addArrangedSubview(UIView())
                stack.addArrangedSubview(linkButton)
            }
            workoutHistory.configureCell { cell in
                cell.backgroundColor = .secondarySystemGroupedBackground
                cell.horizontalPadding(16)
                cell.selectionStyle = .default
            }
            workoutHistoryRows.append(workoutHistory)
        }
    }
}

// MARK: - Preview
#Preview {
    WorkoutViewController()
}
