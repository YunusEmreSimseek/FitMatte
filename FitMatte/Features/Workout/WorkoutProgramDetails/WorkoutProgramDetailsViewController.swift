//
//  WorkoutProgramDetailsViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 24.10.2025.
//
import UIKit

final class WorkoutProgramDetailsViewController: BaseViewController<WorkoutProgramDetailsViewModel> {
    init(workoutProgram: WorkoutProgram) { super.init(viewModel: WorkoutProgramDetailsViewModel(workoutProgram: workoutProgram))}
    
    // MARK: - UI Components
    private var headerStack = StackRow()
    private var daySections: [BaseSection] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTableStyle(.insetGrouped)
        changeTableSeparatorStyle(.singleLine)
        setup()
    }
    
    // MARK: - Setup
    private func setup(){
        configureHeaderStack()
        configureDaySections()
        addSection([headerStack])
        for section in daySections {
            addSection(section.rows, title: section.title)
        }
    }
    
    // MARK: - Reload
    private func reload(){
        cleanTable()
        headerStack = .init()
        daySections = []
        setup()
    }
}

// MARK: - Component Configurations
extension WorkoutProgramDetailsViewController {
    private func configureHeaderStack(){
        let cancelButton = TextButton.Cancel
        cancelButton.addAction(UIAction{ [weak self] _ in
            guard let self else { return }
            self.dismiss(animated: true)
        }, for: .touchUpInside)
        let titleLabel = BaseLabel(viewModel.workoutProgram.name, ThemeFont.defaultTheme.boldText)
        titleLabel.textAlignment = .center
        let saveButton = TextButton.Save
        
        headerStack.configureView { stack in
            stack.addArrangedSubview(cancelButton)
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(saveButton)
            stack.distribution = .equalSpacing
            titleLabel.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.5).isActive = true
        }
    }
    
    private func configureDaySections() {
        for day in viewModel.workoutProgram.days {
            var exercises: [StackRow] = []
            for exercise in day.exercises {
                let titleLabel = BaseLabel("\(exercise.name):", ThemeFont.defaultTheme.semiBoldMediumText)
                titleLabel.widthAnchor.constraint(equalToConstant: view.dynamicWidth(0.12)).isActive = true
                titleLabel.numberOfLines = 0
                let detailsLabel = BaseLabel("\(exercise.sets) x \(exercise.reps) @ \(exercise.weight) kg", ThemeFont.defaultTheme.mediumText)
                let deleteButton: UIButton = {
                    let button = UIButton(type: .system)
                    button.setImage(UIImage(systemName: "trash"), for: .normal)
                    button.tintColor = .systemRed
                    return button
                }()
                var stack = StackRow()
                stack.configureView { [weak self] stack in
                    guard let self else { return }
                    stack.addArrangedSubview(titleLabel)
                    stack.addArrangedSubview(detailsLabel)
                    stack.addArrangedSubview(UIView())
                    stack.addArrangedSubview(deleteButton)
                    stack.spacing = 16
                    stack.heightAnchor.constraint(greaterThanOrEqualToConstant: getRowHeight() ).isActive = true
                }
                stack.configureCell { cell in
                    cell.backgroundColor = .secondarySystemBackground
                    cell.horizontalPadding(16)
                }
                exercises.append(stack)
            }
            let section = BaseSection(exercises, title: day.name)
            daySections.append(section)
        }
    }
}

// MARK: - Helper Methods
extension WorkoutProgramDetailsViewController{
    private func getRowHeight() -> CGFloat {
        return view.dynamicHeight(0.036)
    }
}

// MARK: - Preview
#Preview {
    WorkoutProgramDetailsViewController(workoutProgram: .dummyProgram1)
}

