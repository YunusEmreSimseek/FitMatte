//
//  WorkoutLogDetailsViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 24.10.2025.
//
import UIKit

final class WorkoutLogDetailsViewController: BaseViewController<WorkoutLogDetailsViewModel> {
    init(workoutLog: WorkoutLog) { super.init(viewModel: WorkoutLogDetailsViewModel(workoutLog: workoutLog)) }
    
    // MARK: - UI Components
    private var titleRow = LabelRow()
    private var dateRow = LabelRow()
    private var programNameRow = LabelRow()
    private var dayNameRow = LabelRow()
    private var exerciseRows: [StackRow] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTableStyle(.insetGrouped)
        changeTableSeparatorStyle(.singleLine)
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        configureTitleRow()
        configureDateRow()
        configureProgramNameRow()
        configureDayNameRow()
        configureExerciseRows()
        addSection([titleRow])
        addSection([dateRow], title: "Date")
        addSection([programNameRow], title: "Program")
        addSection([dayNameRow], title: "Day")
        addSection(exerciseRows, title: "Exercises")
    }
    
    // MARK: - Reload
    private func reload() {}
}

// MARK: - Component Configurations
extension WorkoutLogDetailsViewController {
    private func configureTitleRow() {
    
        titleRow.configureView { label in
            label.text = "Detail of Train"
            label.font = ThemeFont.defaultTheme.boldText
            label.textAlignment = .center
        }
    }
    
    private func configureDateRow() {
        dateRow.configureView { [weak self] label in
            guard let self else { return }
            label.text = self.viewModel.workoutLog.date.formatted(date: .long, time: .omitted)
            label.heightAnchor.constraint(equalToConstant: self.getRowHeight()).isActive = true
        }
        
        dateRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    
    private func configureProgramNameRow() {
        programNameRow.configureView { [weak self] label in
            guard let self else { return }
            label.text = self.viewModel.workoutLog.programName
            label.heightAnchor.constraint(equalToConstant: self.getRowHeight()).isActive = true
        }
        
        programNameRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    
    private func configureDayNameRow() {
        dayNameRow.configureView { [weak self] label in
            guard let self else { return }
            label.text = self.viewModel.workoutLog.dayName
            label.heightAnchor.constraint(equalToConstant: self.getRowHeight()).isActive = true
        }
        
        dayNameRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    
    private func configureExerciseRows() {
        for exercise in viewModel.workoutLog.exercises {
            var row = StackRow()
            let titleLabel = BaseLabel(exercise.name)
            let detailsLabel = BaseLabel("\(exercise.sets) sets x \(exercise.reps) reps,  \(exercise.weight) kg", ThemeFont.defaultTheme.mediumText)
            detailsLabel.textColor = .secondaryLabel
            row.configureView { stack in
                stack.axis = .vertical
                stack.addArrangedSubview(titleLabel)
                stack.addArrangedSubview(detailsLabel)
                stack.spacing = 4
            }
            
            row.configureCell { cell in
                cell.backgroundColor = .secondarySystemGroupedBackground
                cell.horizontalPadding(16)
            }
            exerciseRows.append(row)
        }
     }
}

// MARK: - Helper Methods
extension WorkoutLogDetailsViewController {
    private func getRowHeight() -> CGFloat {
        return view.dynamicHeight(0.036)
    }
}

// MARK: - Preview
#Preview {
    WorkoutLogDetailsViewController(workoutLog: .dummyLog3)
}
