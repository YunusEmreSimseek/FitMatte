//
//  EditUserProfileViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 20.10.2025.
//
import UIKit

final class EditUserProfileViewController: BaseViewController<EditUserProfileViewModel> {
    init() { super.init(viewModel: EditUserProfileViewModel()) }
    
    // MARK: - Properties
    private var nameStack = StackRow()
    private var emailStack = StackRow()
    private var bodyStack = StackRow()
    private var birthdayStack = StackRow()
    private var goalsAndLevelStack = StackRow()
    private var stepGoalStack = StackRow()
    private var informationStack = StackRow()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addAllPadding()
        setup()
    }
    
    private func setup() {
        configureNameStack()
        configureEmailStack()
        configureBodyStack()
        configureBirthdayStack()
        configureGoalsAndLevelStack()
        configureStepGoalStack()
        configureInformationStack()
        addSection([
            nameStack,
            emailStack,
            bodyStack,
            birthdayStack,
            goalsAndLevelStack,
            stepGoalStack,
            informationStack
        ])
    }
}

// MARK: - Configure Rows
extension EditUserProfileViewController {
    private func configureNameStack() {
        let nameTitle = createTitleLabel("Name")
        let nameTextField: BaseTextField = {
            let textField = BaseTextField(text: viewModel.currentUser.name)
            textField.textContentType = .name
            return textField
        }()
        nameStack.configureView { stack in
            stack.axis = .vertical
            stack.spacing = 4
            stack.addArrangedSubview(nameTitle)
            stack.addArrangedSubview(nameTextField)
        }
    }
    
    private func configureEmailStack() {
        let emailTitle = createTitleLabel("Email")
        let emailTextField: BaseTextField = {
            let textField = BaseTextField(text: viewModel.currentUser.email)
            textField.textContentType = .emailAddress
            textField.keyboardType = .emailAddress
            return textField
        }()
        emailStack.configureView { stack in
            stack.axis = .vertical
            stack.spacing = 4
            stack.addArrangedSubview(emailTitle)
            stack.addArrangedSubview(emailTextField)
        }
    }
    
    private func configureBodyStack() {
        let weightTitle = createTitleLabel("Weight")
        let weightTextField: BaseTextField = {
            let textField = BaseTextField(text: viewModel.currentUser.weight?.description ?? "")
            textField.keyboardType = .numberPad
            return textField
        }()
        let weightStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [weightTitle, weightTextField])
            stack.axis = .vertical
            stack.spacing = 4
            return stack
        }()
        let heightTitle = createTitleLabel("Height")
        let heightTextField: BaseTextField = {
            let textField = BaseTextField(text: viewModel.currentUser.height?.description ?? "")
            textField.keyboardType = .numberPad
            return textField
        }()
        let heightStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [heightTitle, heightTextField])
            stack.axis = .vertical
            stack.spacing = 4
            return stack
        }()
        let genderTitle = createTitleLabel("Gender")
        let genderMenuButton = MenuButton(["Male", "Female"])
        let genderStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [genderTitle, genderMenuButton])
            stack.axis = .vertical
            stack.spacing = 4
            return stack
        }()
        bodyStack.configureView { stack in
            stack.distribution = .fillEqually
            stack.spacing = 12
            stack.addArrangedSubview(weightStack)
            stack.addArrangedSubview(heightStack)
            stack.addArrangedSubview(genderStack)
        }
    }
    
    private func configureBirthdayStack() {
        let birthdayTitle = createTitleLabel("Birthday")
        let birthdayTextField: BaseTextField = {
            let textField = BaseTextField("Select your birthday")
            return textField
        }()
        let birthdayDatePicker: UIDatePicker = {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .compact
            datePicker.maximumDate = Date()
            datePicker.date = self.viewModel.currentUser.birthDate ?? Date()
            return datePicker
        }()
        let birthdayView: UIView = {
            let view = UIView()
            view.addSubview(birthdayTextField)
            view.addSubview(birthdayDatePicker)
            birthdayTextField.translatesAutoresizingMaskIntoConstraints = false
            birthdayDatePicker.translatesAutoresizingMaskIntoConstraints = false
            birthdayTextField.fillSuperview()
            birthdayDatePicker.fillVerticallySuperview()
            NSLayoutConstraint.activate([
                birthdayDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            return view
        }()
        birthdayStack.configureView { stack in
            stack.axis = .vertical
            stack.spacing = 4
            stack.addArrangedSubview(birthdayTitle)
            stack.addArrangedSubview(birthdayView)
        }
    }
    
    private func configureGoalsAndLevelStack() {
        let goalsTitle = createTitleLabel("Goals to Achieve")
        let goalsMenuButton = MenuButton(["Lose Weight", "Build Muscle", "Improve Endurance", "Increase Flexibility"])
        let goalsStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [goalsTitle, goalsMenuButton])
            stack.axis = .vertical
            stack.spacing = 4
            return stack
        }()
        let levelTitle = createTitleLabel("Fitness Level")
        let levelMenuButton = MenuButton(["Beginner", "Intermediate", "Advanced"])
        let levelStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [levelTitle, levelMenuButton])
            stack.axis = .vertical
            stack.spacing = 4
            return stack
        }()
        goalsAndLevelStack.configureView { stack in
            stack.axis = .horizontal
            stack.spacing = 32
            stack.distribution = .fillEqually
            stack.addArrangedSubview(goalsStack)
            stack.addArrangedSubview(levelStack)
        }
    }
    
    private func configureStepGoalStack() {
        let stepGoalTitle = createTitleLabel("Daily Step Goal")
        let stepGoalValue: BaseLabel = {
            let label = BaseLabel("\(self.viewModel.currentUser.stepGoal?.description ?? "") steps", ThemeFont.defaultTheme.semiBoldMediumText)
            label.textAlignment = .center
            return label
        }()
        let stepGoalSlider: UISlider = {
            let slider = UISlider()
            slider.minimumValue = 1000
            slider.maximumValue = 30000
            slider.value = Float(self.viewModel.currentUser.stepGoal ?? 10000)
            let configuration = UIImage.SymbolConfiguration(pointSize: 12)
            if let smallThumbImage = UIImage(systemName: "circle.fill", withConfiguration: configuration) {
                slider.setThumbImage(smallThumbImage, for: .normal)
                slider.setThumbImage(smallThumbImage, for: .highlighted)
            }
            return slider
        }()
        let minValueLabel = BaseLabel("1000", ThemeFont.defaultTheme.smallText)
        let maxValueLabel = BaseLabel("30000", ThemeFont.defaultTheme.smallText)
        let sliderLabelsStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [minValueLabel, UIView(), maxValueLabel])
            stack.axis = .horizontal
            return stack
        }()
        let stepGoalSliderStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [stepGoalValue, stepGoalSlider, sliderLabelsStack])
            stack.axis = .vertical
            stack.spacing = .zero
            stack.toCard()
            return stack
        }()
        stepGoalStack.configureView { stack in
            stack.axis = .vertical
            stack.spacing = 4
            stack.addArrangedSubview(stepGoalTitle)
            stack.addArrangedSubview(stepGoalSliderStack)
        }
    }
    
    private func configureInformationStack() {
        let infoTitle = BaseLabel("Your Trust Matter for Us", ThemeFont.defaultTheme.boldMediumText)
        let infoDescription: BaseLabel = {
            let label = BaseLabel()
            label.text = "Please provide your email address to receive important updates and notifications about your account. We value your privacy and will not share your information with third parties."
            label.font = ThemeFont.defaultTheme.mediumText
            label.textColor = .secondaryLabel
            return label
        }()
        informationStack.configureView { stack in
            stack.axis = .vertical
            stack.spacing = 8
            stack.addArrangedSubview(infoTitle)
            stack.addArrangedSubview(infoDescription)
            stack.toCard()
        }
    }
}

// MARK: - Common Views
extension EditUserProfileViewController {
    private func createTitleLabel(_ text: String) -> BaseLabel {
        let label = BaseLabel(text, ThemeFont.defaultTheme.semiBoldMediumText)
        label.textColor = .secondaryLabel
        return label
    }
}

// MARK: - Preview
#Preview {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .systemBackground
    appearance.configureWithOpaqueBackground()
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().standardAppearance = appearance
    let nav = UINavigationController(rootViewController: EditUserProfileViewController())
    return nav
}
