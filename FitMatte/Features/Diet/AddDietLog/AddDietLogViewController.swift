//
//  AddDietLogViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 23.10.2025.
//
import Combine
import UIKit

final class AddDietLogViewController: BaseViewController<AddDietLogViewModel> {
    init() { super.init(viewModel: AddDietLogViewModel()) }
    
    // MARK: - UI Components
    private var headerStack = StackRow()
    private var dateStack = StackRow()
    private var stepsStack = StackRow()
    private var cardioStack = StackRow()
    private var caloriesStack = StackRow()
    private var proteinsStack = StackRow()
    private var carbsStack = StackRow()
    private var fatsStack = StackRow()
    private var noteStack = TextFieldRow()
    
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
        configureStepsStack()
        configureCardioStack()
        configureCaloriesStack()
        configureProteinsStack()
        configureCarbsStack()
        configureFatsStack()
        configureNoteStack()
        addSection([headerStack])
        addSection([dateStack], title: "Date")
        addSection([stepsStack], title: "Activity")
        addSection([
            cardioStack,
            caloriesStack,
            proteinsStack,
            carbsStack,
            fatsStack,
            noteStack
        ], title: "Daily Informations")
     }
    
    // MARK: - Reload
    private func reload() {
        cleanTable()
        headerStack = .init()
        dateStack = .init()
        stepsStack = .init()
        cardioStack = .init()
        caloriesStack = .init()
        proteinsStack = .init()
        carbsStack = .init()
        fatsStack = .init()
        noteStack = .init()
        setup()
    }
}

// MARK: - Component Configurations
extension AddDietLogViewController {
    private func configureHeaderStack() {
        let cancelButton: UIButton = {
            let button = TextButton.Cancel
            button.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                self.dismiss(animated: true)
            }, for: .touchUpInside)
            return button
        }()
        let titleLabel = BaseLabel("Daily Diet Log", ThemeFont.defaultTheme.boldText)
        let saveButton: UIButton = {
            let button = TextButton.Save
            button.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                Task {
                    await self.viewModel.saveDietLog()
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
        }
     }
    
    private func configureDateStack() {
        let dateTitleLabel = createTitleLabel("Date")
        let datePicker: UIDatePicker = {
            let picker = UIDatePicker()
            picker.datePickerMode = .date
            picker.preferredDatePickerStyle = .compact
            picker.date = viewModel.selectedDate
            picker.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                self.viewModel.selectedDate = picker.date
                reload()
            }, for: .valueChanged)
            return picker
        }()
        dateStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(dateTitleLabel)
            stack.addArrangedSubview(datePicker)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        dateStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.cornerConfiguration = .corners(radius: 16)
        }
    }
    
    private func configureStepsStack() {
        let iv: UIImageView = {
            let iv = UIImageView(image: .init(systemName: "figure.walk"))
            iv.contentMode = .scaleAspectFit
            iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
            return iv
        }()
        let titleLabel = createTitleLabel("Steps Number")
        let titleValueLabel = createTitleLabel("\(viewModel.stepsNumber)")
        
        stepsStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.spacing = 16
            stack.addArrangedSubview(iv)
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(UIView())
            stack.addArrangedSubview(titleValueLabel)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        
        stepsStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.cornerConfiguration = .corners(radius: 16)
        }
    }
    
    private func configureCardioStack() {
        let titleLabel = createTitleLabel("Cardio Minutes")
        let titleValueField: UITextField = {
            let field = createValueField("min")
            field.textPublisher
                .dropFirst()
                .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                .receive(on: RunLoop.main)
                .sink { [weak self] newValue in
                    guard let self else { return }
                    self.viewModel.cardioMinutes = Int(newValue) ?? 0
                }
                .store(in: &cancellables)
            return field
        }()
        
        cardioStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(titleValueField)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        
        cardioStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    
    private func configureCaloriesStack() {
        let titleLabel = createTitleLabel("Calories Consumed")
        let titleValueField = createValueField("kcal")
        titleValueField.textPublisher
            .dropFirst()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                guard let self else { return }
                self.viewModel.caloriesConsumed = Int(newValue) ?? 0
            }
            .store(in: &cancellables)
        
        caloriesStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(titleValueField)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        
        caloriesStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    
    private func configureProteinsStack() {
        let titleLabel = createTitleLabel("Proteins")
        let titleValueField = createValueField("g")
        titleValueField.textPublisher
            .dropFirst()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                guard let self else { return }
                self.viewModel.proteinConsumed = Int(newValue) ?? 0
            }
            .store(in: &cancellables)
        
        proteinsStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(titleValueField)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        
        proteinsStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    
    private func configureCarbsStack() {
        let titleLabel = createTitleLabel("Carbs")
        let titleValueField = createValueField("g")
        titleValueField.textPublisher
            .dropFirst()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                guard let self else { return }
                self.viewModel.carbsConsumed = Int(newValue) ?? 0
            }
            .store(in: &cancellables)
        
        carbsStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(titleValueField)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        
        carbsStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    
    private func configureFatsStack() {
        let titleLabel = createTitleLabel("Fats")
        let titleValueField = createValueField("g")
        titleValueField.textPublisher
            .dropFirst()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] newValue in
                guard let self else { return }
                self.viewModel.fatsConsumed = Int(newValue) ?? 0
            }
            .store(in: &cancellables)
        
        fatsStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(titleValueField)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        
        fatsStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    
    private func configureNoteStack() {
        noteStack.configureView { [weak self] field in
            guard let self else { return }
            field.placeholder = "Note (optional)"
            field.font = ThemeFont.defaultTheme.mediumText
            field.textPublisher
                .dropFirst()
                .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                .sink { [weak self] newValue in
                    guard let self else { return }
                    self.viewModel.note = newValue
                }
                .store(in: &cancellables)
            field.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
         }
        
        noteStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
}

// MARK: - Helper Methods
extension AddDietLogViewController {
    private func createTitleLabel(_ text: String) -> UILabel {
        return BaseLabel(text, ThemeFont.defaultTheme.mediumText)
    }
    
    private func createValueField(_ placeHolder: String) -> UITextField {
        let field = UITextField()
        field.placeholder = placeHolder
        field.font = ThemeFont.defaultTheme.mediumText
        field.textAlignment = .right
        field.keyboardType = .numberPad
        return field
    }
    
    private func getRowHeight() -> CGFloat {
        return view.dynamicHeight(0.036)
    }
}
    
// MARK: - Preview
#Preview {
    AddDietLogViewController()
}
