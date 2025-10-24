//
//  AddWorkoutViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 21.10.2025.
//
import Combine
import UIKit

final class AddWorkoutViewController: BaseViewController<AddWorkoutViewModel> {
    init() { super.init(viewModel: AddWorkoutViewModel()) }
    
//    let completion: ((Bool) -> Void)? = nil
    
    // MARK: - UI Components
    private var headerStack = StackRow()
    private var workoutNameStack = TextFieldRow()
    private var numberOfDaysStack = StackRow()
    private var daysAndExerciseStacks: [StackRow] = []
    
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
        configureWorkoutNameStack()
        configureNumberOfDaysStack()
        configureDaysAndExerciseStacks()
        addSection([headerStack])
        addSection([workoutNameStack], title: "Workout Name")
        addSection([numberOfDaysStack], title: "Number of Days per Week")
        addSection(daysAndExerciseStacks, title: "Days and Exercises")
    }
    
    // MARK: - Reload
    private func reload() {
        headerStack = .init()
        workoutNameStack = .init()
        numberOfDaysStack = .init()
        daysAndExerciseStacks = []
        cleanTable()
        setup()
    }
}

// MARK: - Component Configurations
extension AddWorkoutViewController {
    private func configureHeaderStack() {
        let cancelButton: UIButton = {
            let button = UIButton(type: .system)
            var cfg = UIButton.Configuration.plain()
            cfg.title = "Cancel"
            cfg.font(ThemeFont.defaultTheme.text)
            button.configuration = cfg
            button.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                self.dismiss(animated: true)
            }, for: .touchUpInside)
            return button
        }()
        let titleLabel = BaseLabel("New Workout", ThemeFont.defaultTheme.boldText)
        titleLabel.textAlignment = .center
        let saveButton: UIButton = {
            let button = UIButton(type: .system)
            var cfg = UIButton.Configuration.plain()
            cfg.title = "Save"
            cfg.font(ThemeFont.defaultTheme.text)
            button.configuration = cfg
            button.addAction(UIAction{ [weak self] _ in
                guard let self else { return }
                Task {
                    let response = await self.viewModel.saveWorkout()
                    if response {
                        self.dismiss(animated: true)
                        return
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
            titleLabel.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.5).isActive = true
        }
    }
    
    private func configureWorkoutNameStack() {
        workoutNameStack.configureView { [weak self] textField in
            guard let self else { return }
            textField.placeholder = "e.g. Current Program"
            textField.font = ThemeFont.defaultTheme.boldMediumText
            textField.textPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] newValue in
                    guard let self else { return }
                    self.viewModel.workoutName = newValue
                }
                .store(in: &self.cancellables)
            textField.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        workoutNameStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.cornerConfiguration = .corners(radius: 16)
            cell.horizontalPadding(16)
        }
    }
        
    private func configureNumberOfDaysStack() {
        let titleLabel = BaseLabel("\(viewModel.numberOfDaysPerWeek) days", ThemeFont.defaultTheme.mediumText)
        
        let stepper: UIStepper = {
            let stepper = UIStepper()
            stepper.minimumValue = 1
            stepper.maximumValue = 7
            stepper.value = Double(viewModel.numberOfDaysPerWeek)
            stepper.stepValue = 1
            stepper.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                self.viewModel.updateNumberOfDaysPerWeek(to: Int(stepper.value))
                reload()
            }, for: .valueChanged)
            return stepper
        }()
        
        numberOfDaysStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(UIView())
            stack.addArrangedSubview(stepper)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        
        numberOfDaysStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.cornerConfiguration = .corners(radius: 16)
            cell.horizontalPadding(16)
        }
    }
    
    private func configureDaysAndExerciseStacks() {
        for day in viewModel.workoutDays {
            var exerciseRows: [UILabel] = []
            let dayNameField = createTextField(day)
            for exercise in day.exercises {
                let exerciseLabel: BaseLabel = {
                    let label = BaseLabel()
                    label.text = "•   \(exercise.name)   (\(exercise.sets)x\(exercise.reps) - \(exercise.weight)kg)"
                    label.font = ThemeFont.defaultTheme.mediumText
                    return label
                }()
                exerciseRows.append(exerciseLabel)
            }
            let addButton = UIButton(type: .contactAdd)
            addButton.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                self.present(AddExerciseViewController { [weak self] exercise in
                    guard let self else { return }
                    guard let exercise else { return }
                    viewModel.addExercise(exercise, toDay: day.order)
                    reload()
                }, animated: true)
            }, for: .touchUpInside)
            let addTitleLabel = BaseLabel("Add Exercise", ThemeFont.defaultTheme.mediumText)
            let addHStack: UIStackView = {
                let stack = UIStackView(arrangedSubviews: [addButton, addTitleLabel])
                stack.spacing = 16
                return stack
            }()
            var stack = StackRow()
            stack.configureView { stack in
                stack.axis = .vertical
                stack.spacing = 8
                stack.addArrangedSubview(dayNameField)
                for exerciseRow in exerciseRows {
                    stack.addArrangedSubview(exerciseRow)
                }
                stack.addArrangedSubview(addHStack)
            }
            stack.configureCell { cell in
                cell.backgroundColor = .secondarySystemGroupedBackground
                cell.horizontalPadding(16)
                cell.topPadding(12)
//                cell.bottomPadding(12)
            }
            daysAndExerciseStacks.append(stack)
        }
    }
}

// MARK: - Helper Methods
extension AddWorkoutViewController {
    private func createTextField(_ day: WorkoutDay) -> UITextField {
        let field = UITextField()
        field.text = day.name
        field.font = ThemeFont.defaultTheme.boldMediumText
        field.placeholder = "Day Name"
        field.textPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                guard let self else { return }
                let newDay = WorkoutDay(name: newValue, order: day.order, exercises: day.exercises)
                self.viewModel.updateDay(newDay)
            }
            .store(in: &cancellables)
//        field.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        return field
    }
    
    private func getRowHeight() -> CGFloat {
        return view.dynamicHeight(0.036)
    }
}

// MARK: - Preview
#Preview {
    UINavigationController(rootViewController: AddWorkoutViewController())
}
