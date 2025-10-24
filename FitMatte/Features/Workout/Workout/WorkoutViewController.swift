//
//  WorkoutViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 21.10.2025.
//
import Combine
import DGCharts
import UIKit

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
            .sink { [weak self] _ in
                guard let self else { return }
                self.reload()
            }
            .store(in: &cancellables)
        viewModel.workoutManager.$workoutLogs
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
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

    private func configureWorkoutSummaryChartRow() {
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let grouped = Dictionary(grouping: viewModel.workoutManager.workoutLogs) {
            Calendar.current.component(.weekday, from: $0.date)
        }
        let chart: BarChartView = {
            let chartView = BarChartView()
            chartView.translatesAutoresizingMaskIntoConstraints = false
            chartView.pinchZoomEnabled = false
            chartView.drawBarShadowEnabled = false
            chartView.doubleTapToZoomEnabled = false
            chartView.legend.horizontalAlignment = .center
            chartView.xAxis.labelPosition = .bottom
            chartView.rightAxis.enabled = false
            chartView.xAxis.granularity = 1
            chartView.animate(yAxisDuration: 1.0)
            return chartView
        }()
        var entries: [BarChartDataEntry] = []
        for i in 0 ..< days.count {
            let entry = BarChartDataEntry(x: Double(i), y: Double(grouped[i]?.count ?? 0))
            entries.append(entry)
        }
        let dataSet = BarChartDataSet(entries: entries, label: "Average Workouts per Day")
        dataSet.colors = [UIColor.systemBlue]
//        dataSet.valueTextColor = .black
        let data = BarChartData(dataSet: dataSet)
        chart.data = data
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        chart.notifyDataSetChanged()
        workoutSummaryChartRow.configureView { view in
            view.addSubview(chart)
            chart.fillSuperview()
            chart.heightAnchor.constraint(equalToConstant: 200).isActive = true
        }

        workoutSummaryChartRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
        }
    }

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

            workoutProgram.configureDidSelect {
                guard let navController = self.navigationController else { return }
                navController.present(WorkoutProgramDetailsViewController(workoutProgram: program), animated: true)
            }

            workoutProgram.addContextMenuAction(UIAction(title: "Delete", image: .init(systemName: "trash"), attributes: .destructive, handler: { _ in
                let alert = UIAlertController(title: "Delete Workout Program", message: "Are you sure you want to delete the workout program \"\(program.name)\"?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    alert.dismiss(animated: true)
                }))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                    guard let self else { return }
                    guard let id = program.id else { return }
                    Task {
                        let response = await self.viewModel.workoutManager.deleteWorkoutProgram(id)
                        if response {
                            self.reload()
                        }
                    }

                }))
                self.present(alert, animated: true)
            }))

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

            workoutHistory.configureDidSelect {
                guard let navController = self.navigationController else { return }
                navController.present(WorkoutLogDetailsViewController(workoutLog: workoutLog), animated: true)
            }
            workoutHistoryRows.append(workoutHistory)
        }
    }
}

// MARK: - Preview
#Preview {
    UINavigationController(rootViewController: WorkoutViewController())
}
