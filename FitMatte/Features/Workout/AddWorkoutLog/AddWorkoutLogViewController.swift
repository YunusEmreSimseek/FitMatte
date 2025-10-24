//
//  AddWorkoutLogViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 23.10.2025.
//
import UIKit

final class AddWorkoutLogViewController: BaseViewController<AddWorkoutLogViewModel> {
    init() { super.init(viewModel: AddWorkoutLogViewModel()) }
    
    // MARK: - UI Components
    private var headerStack = StackRow()
    private var dateStack = StackRow()
    private var workoutStack = StackRow()
    private var dayStack = StackRow()
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
        configureHeaderStack()
        configureDateStack()
        configureWorkoutStack()
        configureDayStack()
        configureExercisesStack()
        addSection([headerStack])
        addSection([dateStack], title: "Choose a Date")
        addSection([workoutStack, dayStack], title: "Choose a Workout Program")
        if !exerciseRows.isEmpty {
            addSection(exerciseRows, title: "Exercises")
        }
    }
    
    // MARK: - Reload
    private func reload() {
        cleanTable()
        headerStack = .init()
        dateStack = .init()
        workoutStack = .init()
        dayStack = .init()
        exerciseRows = []
        setup()
    }
}

// MARK: - Component Configurations
extension AddWorkoutLogViewController {
    private func configureHeaderStack() {
        let cancelButton = CancelButton()
        cancelButton.addAction(UIAction{ [weak self] _ in
            guard let self else { return }
            self.dismiss(animated: true)
        }, for: .touchUpInside)
        let titleLabel = BaseLabel("Save a Train", ThemeFont.defaultTheme.boldText)
        let saveButton: UIButton = {
            let button = UIButton(type: .system)
            var cfg = UIButton.Configuration.plain()
            cfg.title = "Save"
            cfg.font(ThemeFont.defaultTheme.text)
            button.configuration = cfg
            button.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                Task {
                    let response = await self.viewModel.saveWorkoutLog()
                    if response {
                        self.dismiss(animated: true)
                    }
                }
                
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
    
    private func configureDateStack() {
        let titleLabel = BaseLabel("Date", ThemeFont.defaultTheme.mediumText)
        let datePicker: UIDatePicker = {
            let picker = UIDatePicker()
            picker.date = viewModel.selectedDate
            picker.datePickerMode = .date
            picker.preferredDatePickerStyle = .compact
            picker.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                self.viewModel.selectedDate = picker.date
            }, for: .valueChanged)
            return picker
        }()
        dateStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(datePicker)
            stack.heightAnchor.constraint(equalToConstant: self.getRowHeight()).isActive = true
        }
        dateStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.cornerConfiguration = .corners(radius: 16)
            cell.horizontalPadding(16)
        }
    }
    
    private func configureWorkoutStack() {
        let titleLabel = BaseLabel("Workout Program", ThemeFont.defaultTheme.mediumText)
        var menuActions: [UIAction] = []
        if let workoutProgram = viewModel.selectedWorkoutProgram {
            menuActions.append(UIAction(title: workoutProgram.name, handler: { [weak self] _ in
                guard let self else { return }
                self.viewModel.selectedWorkoutProgram = workoutProgram
            }))
        }
        menuActions.append(UIAction(title: "Dont Select") { [weak self] _ in
            guard let self else { return }
            self.viewModel.selectedWorkoutProgram = nil
            self.viewModel.selectedWorkoutDay = nil
            self.viewModel.exercises = []
            self.reload()
        })
        var actions = viewModel.workoutManager.workoutPrograms.map { workoutProgram in
            UIAction(title: workoutProgram.name) { [weak self] _ in
                guard let self else { return }
                self.viewModel.selectedWorkoutProgram = workoutProgram
                self.reload()
            }
        }
        if let workoutProgram = viewModel.selectedWorkoutProgram {
            actions.removeAll { $0.title == workoutProgram.name }
        }
        menuActions.append(contentsOf: actions)
        let menu = UIMenu(options: .singleSelection, children: menuActions)
        
        let selectButton: UIButton = {
            let button = UIButton(type: .system)
            button.configuration = .plain()
            button.showsMenuAsPrimaryAction = true
            button.changesSelectionAsPrimaryAction = true
            button.menu = menu
            return button
        }()
        workoutStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(selectButton)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        workoutStack.configureCell { [weak self] cell in
            guard let self else { return }
            cell.backgroundColor = .secondarySystemGroupedBackground
            if self.viewModel.selectedWorkoutProgram == nil {
                cell.cornerConfiguration = .corners(radius: 16)
            }
            cell.horizontalPadding(16)
        }
    }
    
    private func configureDayStack() {
        guard let workoutProgram = viewModel.selectedWorkoutProgram else { return }
        let titleLabel = BaseLabel("Day", ThemeFont.defaultTheme.mediumText)
        var menuActions: [UIAction] = []
        if let workoutDay = viewModel.selectedWorkoutDay {
            menuActions.append(UIAction(title: workoutDay.name, handler: { [weak self] _ in
                guard let self else { return }
                self.viewModel.selectedWorkoutDay = workoutDay
            }))
        }
        menuActions.append(UIAction(title: "Dont Select") { [weak self] _ in
            guard let self else { return }
            self.viewModel.selectedWorkoutDay = nil
            self.viewModel.exercises = []
            self.reload()
        })
        var actions = workoutProgram.days.map { day in
            UIAction(title: day.name) { [weak self] _ in
                guard let self else { return }
                self.viewModel.selectedWorkoutDay = day
                self.viewModel.exercises = day.exercises
                self.reload()
            }
        }
        if let workoutDay = viewModel.selectedWorkoutDay {
            actions.removeAll { $0.title == workoutDay.name }
        }
        menuActions.append(contentsOf: actions)
        let menu = UIMenu(options: .singleSelection, children: menuActions)

        let selectButton: UIButton = {
            let button = UIButton(type: .system)
            button.configuration = .plain()
            button.showsMenuAsPrimaryAction = true
            button.changesSelectionAsPrimaryAction = true
            button.menu = menu
            return button
        }()
        
        dayStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(selectButton)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        
        dayStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    
    private func configureExercisesStack() {
        if  viewModel.selectedWorkoutDay != nil {
            for exercise in viewModel.exercises {
                var exerciseRow = StackRow()
                let exerciseNameLabel = BaseLabel(exercise.name, ThemeFont.defaultTheme.boldMediumText)
                let exerciseSetsLabel = createTitleLabel("Sets: \(exercise.sets)")
                let exerciseRepsLabel = createTitleLabel("Reps: \(exercise.reps)")
                let exerciseWeightLabel = createTitleLabel("Weight: \(exercise.weight) kg")
                let exerciseSetsStepper = createStepper(exercise.sets) { [weak self] newValue in
                    guard let self else { return }
                    let updatedExercise = WorkoutExercise(id: exercise.id, name: exercise.name, sets: newValue, reps: exercise.reps, weight: exercise.weight)
                    self.viewModel.updateExercise(updatedExercise)
                    reload()
                }
                let exerciseRepsStepper = createStepper(exercise.reps) { [weak self] newValue in
                    guard let self else { return }
                    let updatedExercise = WorkoutExercise(id: exercise.id, name: exercise.name, sets: exercise.sets, reps: newValue, weight: exercise.weight)
                    self.viewModel.updateExercise(updatedExercise)
                    reload()
                }
                let exerciseWeightStepper = createStepper(Int(exercise.weight)) { [weak self] newValue in
                    guard let self else { return }
                    let updatedExercise = WorkoutExercise(id: exercise.id, name: exercise.name, sets: exercise.sets, reps: exercise.reps, weight: Double(newValue))
                    self.viewModel.updateExercise(updatedExercise)
                    reload()
                }
                let setsStack = UIStackView(arrangedSubviews: [exerciseSetsLabel, exerciseSetsStepper])
                let repsStack = UIStackView(arrangedSubviews: [exerciseRepsLabel, exerciseRepsStepper])
                let weightStack = UIStackView(arrangedSubviews: [exerciseWeightLabel, exerciseWeightStepper])
                
                exerciseRow.configureView { stack in
                    stack.axis = .vertical
                    stack.spacing = 2
                    stack.addArrangedSubview(exerciseNameLabel)
                    stack.addArrangedSubview(setsStack)
                    stack.addArrangedSubview(repsStack)
                    stack.addArrangedSubview(weightStack)
                }
                
                exerciseRow.configureCell { cell in
                    cell.backgroundColor = .secondarySystemGroupedBackground
                    cell.horizontalPadding(16)
//                    cell.verticalPadding(16)
                }
                
                exerciseRows.append(exerciseRow)
                 }
         }
    }
}

// MARK: - Helper Methods
extension AddWorkoutLogViewController {
    private func createTitleLabel(_ text: String) -> BaseLabel {
        let label = BaseLabel(text, ThemeFont.defaultTheme.mediumText)
        return label
    }
        
    private func createStepper(_ value: Int, onChanged: @escaping (Int) -> Void) -> UIStepper {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 500
        stepper.stepValue = 1
        stepper.value = Double(value)
        stepper.addAction(UIAction { _ in
            onChanged(Int(stepper.value))
        }, for: .touchUpInside)
        return stepper
    }
    
    private func getRowHeight() -> CGFloat {
        return view.dynamicHeight(0.036)
    }
}
    
// MARK: - Preview
#Preview {
    AddWorkoutLogViewController()
}
