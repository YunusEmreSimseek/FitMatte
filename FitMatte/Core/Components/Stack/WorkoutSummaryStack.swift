//
//  WorkoutSummaryStack.swift
//  FitMatte
//
//  Created by Emre Simsek on 27.10.2025.
//
import DGCharts
import UIKit

final class WorkoutSummaryStack: UIStackView {
    private var workoutLogs: [WorkoutLog]?
    private let totaltrainingLabel = BaseLabel("Total Trainings:")
    private let totalTrainingValueLabel = BaseLabel()
    private let totalTrainingStack = UIStackView()
    private let weeklyAverageLabel = BaseLabel("Weekly Average:")
    private let weeklyAverageValueLabel = BaseLabel()
    private let weeklyAverageStack = UIStackView()
    private let headerHStack = UIStackView()
    private let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    private let chart = BarChartView()

    private var entries: [BarChartDataEntry] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSelf()
        configureLabel(totaltrainingLabel)
        configureLabel(weeklyAverageLabel)
        configureVStack(totalTrainingStack)
        configureVStack(weeklyAverageStack)
        configureChart(chart)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(_ workoutLogs: [WorkoutLog]) {
        self.workoutLogs = workoutLogs
        configure()
    }

    private func configure() {
        guard let workoutLogs else { return }
        totalTrainingValueLabel.text = "\(workoutLogs.count)"
        totalTrainingStack.addArrangedSubview(totaltrainingLabel)
        totalTrainingStack.addArrangedSubview(totalTrainingValueLabel)
        weeklyAverageValueLabel.text = String(format: "%.2f", Double(workoutLogs.count) / 7.0)
        weeklyAverageStack.addArrangedSubview(weeklyAverageLabel)
        weeklyAverageStack.addArrangedSubview(weeklyAverageValueLabel)
        headerHStack.addArrangedSubview(totalTrainingStack)
        headerHStack.addArrangedSubview(weeklyAverageStack)
        let grouped = Dictionary(grouping: workoutLogs) {
            Calendar.current.component(.weekday, from: $0.date)
        }
        for i in 0 ..< days.count {
            let entry = BarChartDataEntry(x: Double(i), y: Double(grouped[i]?.count ?? 0))
            entries.append(entry)
        }
        let dataSet = BarChartDataSet(entries: entries, label: "Average Workouts per Day")
        dataSet.colors = [UIColor.systemBlue]
        let data = BarChartData(dataSet: dataSet)
        chart.data = data
        chart.notifyDataSetChanged()
    }
}

extension WorkoutSummaryStack {
    private func configureLabel(_ label: UILabel) {
        label.font = ThemeFont.defaultTheme.semiBoldMediumText
        label.textColor = .secondaryLabel
    }

    private func configureVStack(_ stack: UIStackView) {
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
    }

    private func configureChart(_ chart: BarChartView) {
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.pinchZoomEnabled = false
        chart.drawBarShadowEnabled = false
        chart.doubleTapToZoomEnabled = false
        chart.legend.horizontalAlignment = .center
        chart.xAxis.labelPosition = .bottom
        chart.rightAxis.enabled = false
        chart.xAxis.granularity = 1
        chart.animate(yAxisDuration: 1.0)
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        chart.heightAnchor.constraint(equalToConstant: dynamicHeight(0.18)).isActive = true
    }

    private func configureSelf() {
        axis = .vertical
        spacing = 4
        addArrangedSubview(headerHStack)
        addArrangedSubview(chart)
        toCard()
    }
}
