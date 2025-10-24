//
//  AddDietViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 21.10.2025.
//
import UIKit
import Combine

final class AddDietViewController: BaseViewController<AddDietViewModel> {
    init() { super.init(viewModel: AddDietViewModel())}
        
    // MARK: - UI Components
    private var headerStack = StackRow()
    private var durationStack = StackRow()
    private var loseWeightGoalStack = StackRow()
    private var weightGoalStack = StackRow()
    private var stepsCountStack = StackRow()
    private var calorieLimitStack = StackRow()
    private var proteinGoalStack = StackRow()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        changeTableStyle(.insetGrouped)
        changeTableSeparatorStyle(.singleLine)
        setup()
    }
    
    // MARK: - Setup
    private func setup(){
        configureHeaderStack()
        configureDurationStack()
        configureLoseWeightGoalStack()
        configureWeightGoalStack()
        configureStepsCountStack()
        configureCalorieLimitStack()
        configureProteinGoalStack()
        addSection([headerStack])
        addSection([durationStack], title: "DURATION")
        addSection([loseWeightGoalStack, weightGoalStack], title: "WEIGHT GOAL")
        addSection([stepsCountStack, calorieLimitStack, proteinGoalStack], title: "DAILY GOALS")

    }
    
    // MARK: - Reload
    private func reload(){
        cleanTable()
        headerStack = .init()
        durationStack = .init()
        loseWeightGoalStack = .init()
        weightGoalStack = .init()
        stepsCountStack = .init()
        calorieLimitStack = .init()
        proteinGoalStack = .init()
        setup()
    }
}

// MARK: - Component Configurations
extension AddDietViewController {
    private func configureHeaderStack(){
        let cancelButton: UIButton = {
            let button = UIButton(type: .system)
            var cfg = UIButton.Configuration.plain()
            cfg.title = "Cancel"
            cfg.font(ThemeFont.defaultTheme.text)
            button.configuration = cfg
            button.addAction(UIAction{ [weak self] _ in
                guard let self else { return }
                self.dismiss(animated: true)
            }, for: .touchUpInside)
            return button
        }()
        let titleLabel = BaseLabel("Start a New Diet", ThemeFont.defaultTheme.boldText)
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
                    await self.viewModel.saveDiet()
                    self.dismiss(animated: true)
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
    private func configureDurationStack() {
        let stepper: UIStepper = {
            let stepper = UIStepper()
            stepper.minimumValue = 14
            stepper.maximumValue = 360
            stepper.value = Double(viewModel.dietDuration)
            stepper.stepValue = 1
            stepper.addAction(UIAction{ [weak self] _ in
                guard let self else { return }
                self.viewModel.dietDuration = Int(stepper.value)
                reload()
            }, for: .valueChanged)
            return stepper
        }()
        let titleLabel = BaseLabel("Diet Duration: \(Int(viewModel.dietDuration))", ThemeFont.defaultTheme.mediumText)
        
        durationStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.spacing = 8
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(UIView())
            stack.addArrangedSubview(stepper)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        durationStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.cornerConfiguration = .corners(radius: 16)
            cell.horizontalPadding(16)
        }
    }
    private func configureLoseWeightGoalStack() {
        let titleLabel = BaseLabel("Lose Weight Goal:", ThemeFont.defaultTheme.mediumText)
        let valueField = createValueField(value: viewModel.loseWeightGoal.description)
        valueField.textPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                guard let self else { return }
                self.viewModel.loseWeightGoal = Double(newValue) ?? 0
            }
            .store(in: &cancellables)
        loseWeightGoalStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(valueField)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        loseWeightGoalStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    private func configureWeightGoalStack() {
        let titleLabel = BaseLabel("Goal Weight:", ThemeFont.defaultTheme.mediumText)
        let valueField = createValueField(value: viewModel.goalWeight.description)
        valueField.textPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                guard let self else { return }
                self.viewModel.goalWeight = Double(newValue) ?? 0
            }
            .store(in: &cancellables)
        weightGoalStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(valueField)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        weightGoalStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    private func configureStepsCountStack() {
        let titleLabel = BaseLabel("Steps Count:", ThemeFont.defaultTheme.mediumText)
        let valueField = createValueField(value: viewModel.stepCountGoal.description)
        valueField.textPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                guard let self else { return }
                self.viewModel.stepCountGoal = Int(newValue) ?? 0
            }
            .store(in: &cancellables)
        stepsCountStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(valueField)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        stepsCountStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    private func configureCalorieLimitStack() {
        let titleLabel = BaseLabel("Calorie Limit:", ThemeFont.defaultTheme.mediumText)
        let valueField = createValueField(value: viewModel.calorieLimitGoal.description)
        valueField.textPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                guard let self else { return }
                self.viewModel.calorieLimitGoal = Int(newValue) ?? 0
            }
            .store(in: &cancellables)
        calorieLimitStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(valueField)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        calorieLimitStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    private func configureProteinGoalStack() {
        let titleLabel = BaseLabel("Protein Goal:", ThemeFont.defaultTheme.mediumText)
        let valueField = createValueField(value: viewModel.proteinGoal.description)
        valueField.textPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                guard let self else { return }
                self.viewModel.proteinGoal = Int(newValue) ?? 0
            }
            .store(in: &cancellables)
        proteinGoalStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(valueField)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        proteinGoalStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
        
}

// MARK: - Helper Methods
extension AddDietViewController {
    private func createValueField(value:String) -> UITextField {
        let field = UITextField()
        field.font = ThemeFont.defaultTheme.mediumText
        field.keyboardType = .numberPad
        field.textAlignment = .right
        field.text = value
        return field
    }
    
    private func getRowHeight() -> CGFloat {
        return view.dynamicHeight(0.036)
    }
        
}


// MARK: - Preview
#Preview {
    AddDietViewController()
}
