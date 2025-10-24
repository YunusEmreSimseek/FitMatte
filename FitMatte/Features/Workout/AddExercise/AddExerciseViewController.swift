//
//  AddExerciseViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 22.10.2025.
//
import Combine
import UIKit

final class AddExerciseViewController: BaseViewController<AddExerciseViewModel> {
    init(
        _ completion: @escaping ((WorkoutExercise?) -> Void)
    ) {
        self.completion = completion
        super.init(viewModel: AddExerciseViewModel())
    }
    
    let completion: (WorkoutExercise?) -> Void
    
    // MARK: - UI Components
    private var headerStack = StackRow()
    private var exerciseNameRow = TextFieldRow()
    private var setsRow = StackRow()
    private var repsRow = StackRow()
    private var weightRow = StackRow()
    private var noteRow = TextFieldRow()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTableStyle(.insetGrouped)
        changeTableSeparatorStyle(.singleLine)
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        configureHeaderStack()
        configureExerciseNameRow()
        configureSetsRow()
        configureRepsRow()
        configureWeightRow()
        configureNoteRow()
        addSection([headerStack])
        addSection([
            exerciseNameRow,
            setsRow,
            repsRow,
            weightRow,
            noteRow,
        ])
    }
    
    // MARK: - Reload
    private func reload() {
        cleanTable()
        headerStack = .init()
        exerciseNameRow = .init()
        setsRow = .init()
        repsRow = .init()
        weightRow = .init()
        noteRow = .init()
        setup()
    }
}

// MARK: - Component Configurations
extension AddExerciseViewController {
    private func configureHeaderStack() {
        let cancelButton = CancelButton()
        cancelButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.dismiss(animated: true)
        }, for: .touchUpInside)
        let titleLabel = BaseLabel("Add Exercise", ThemeFont.defaultTheme.boldText)
        let saveButton: UIButton = {
            let button = UIButton(type: .system)
            var cfg = UIButton.Configuration.plain()
            cfg.title = "Save"
            cfg.font(ThemeFont.defaultTheme.text)
            button.configuration = cfg
            button.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                let newExercise = WorkoutExercise(
                    name: viewModel.exerciseName,
                    sets: viewModel.sets,
                    reps: viewModel.reps,
                    weight: viewModel.weight,
                    notes: viewModel.notes
                )
                self.completion(newExercise)
                self.dismiss(animated: true)
            }, for: .touchUpInside)
            return button
        }()
        headerStack.configureView { stack in
            stack.distribution = .equalSpacing
            stack.addArrangedSubview(cancelButton)
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(saveButton)
        }
    }

    private func configureExerciseNameRow() {
        exerciseNameRow.configureView { [weak self] textField in
            guard let self else { return }
            textField.placeholder = "Exercise Name"
            textField.text = viewModel.exerciseName
            textField.font = ThemeFont.defaultTheme.mediumText
            textField.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
            textField.textPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] newValue in
                    guard let self else { return }
                    self.viewModel.exerciseName = newValue
                }
                .store(in: &cancellables)
        }
        exerciseNameRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }

    private func configureSetsRow() {
        let titleLabel = BaseLabel("Sets: \(viewModel.sets)", ThemeFont.defaultTheme.mediumText)
        let stepper: UIStepper = {
            let stepper = UIStepper()
            stepper.minimumValue = 1
            stepper.maximumValue = 20
            stepper.value = Double(viewModel.sets)
            stepper.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                self.viewModel.sets = Int(stepper.value)
                reload()
            }, for: .touchUpInside)
            return stepper
        }()
        setsRow.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(stepper)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        setsRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }

    private func configureRepsRow() {
        let titleLabel = BaseLabel("Reps: \(viewModel.reps)", ThemeFont.defaultTheme.mediumText)
        let stepper: UIStepper = {
            let stepper = UIStepper()
            stepper.minimumValue = 1
            stepper.maximumValue = 20
            stepper.value = Double(viewModel.reps)
            stepper.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                self.viewModel.reps = Int(stepper.value)
                reload()
            }, for: .touchUpInside)
            return stepper
        }()
        repsRow.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(stepper)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        repsRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }

    private func configureWeightRow() {
        let titleLabel = BaseLabel("Weight: \(viewModel.weight)", ThemeFont.defaultTheme.mediumText)
        let stepper: UIStepper = {
            let stepper = UIStepper()
            stepper.minimumValue = 1
            stepper.maximumValue = 20
            stepper.value = Double(viewModel.weight)
            stepper.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                self.viewModel.weight = stepper.value
                reload()
            }, for: .touchUpInside)
            return stepper
        }()
        weightRow.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(stepper)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        weightRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }

    private func configureNoteRow() {
        noteRow.configureView { [weak self] textField in
            guard let self else { return }
            textField.placeholder = "Note (optional)"
            textField.text = viewModel.notes
            textField.font = ThemeFont.defaultTheme.mediumText
            textField.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
            textField.textPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] newValue in
                    guard let self else { return }
                    self.viewModel.notes = newValue
                }
                .store(in: &cancellables)
        }
        noteRow.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
}

// MARK: - Helper Methods
extension AddExerciseViewController {
    private func getRowHeight() -> CGFloat {
        return view.dynamicHeight(0.036)
    }
}

// MARK: - Preview
//#Preview {
//    AddExerciseViewController { _ in
//     }
//    AddExerciseViewController()
//}
