//
//  DietLogDetailsViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 24.10.2025.
//
import UIKit

final class DietLogDetailsViewController: BaseViewController<DietLogDetailsViewModel> {
    init(dietLog: DailyDietModel) { super.init(viewModel: DietLogDetailsViewModel(dietLog: dietLog))}
    
    // MARK: - UI Components
    private var titleLabel = LabelRow()
    private var dateStack = StackRow()
    private var stepsStack = StackRow()
    private var cardioStack = StackRow()
    private var calorieStack = StackRow()
    private var proteinsStack = StackRow()
    private var carbsStack = StackRow()
    private var fatsStack = StackRow()
    private var noteLabel = LabelRow()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTableStyle(.insetGrouped)
        changeTableSeparatorStyle(.singleLine)
        setup()
    }
    
    // MARK: - Setup
    private func setup(){
        configureTitleLabel()
        configureDateStack()
        configureStepsStack()
        configureCardioStack()
        configureCalorieStack()
        configureProteinsStack()
        configureCarbsStack()
        configureFatsStack()
        configureNoteLabel()
        addSection([titleLabel])
        addSection([dateStack])
        addSection([stepsStack])
        addSection([cardioStack, calorieStack, proteinsStack, carbsStack, fatsStack, noteLabel], title: "Daily Informations")
    }
    
    // MARK: - Reload
    private func reload(){ }
}

// MARK: - Component Configurations
extension DietLogDetailsViewController {
    private func configureTitleLabel() {
        titleLabel.configureView { label in
            label.text = "Daily Diet Log"
            label.font = ThemeFont.defaultTheme.boldText
            label.textAlignment = .center
        }
    }
    
    private func configureDateStack() {
        let titleLabel = BaseLabel("Date:")
        let valueLabel = BaseLabel(viewModel.dietLog.dateString)
        dateStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(UIView())
            stack.addArrangedSubview(valueLabel)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        
        dateStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    
    private func configureStepsStack() {
        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = .init(systemName: "figure.walk")
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .systemBlue
            imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            return imageView
        }()
        let titleLabel = BaseLabel("Steps Number:")
        let valueLabel = BaseLabel(viewModel.dietLog.stepCount?.description ?? "")
        stepsStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.spacing = 12
            stack.addArrangedSubview(imageView)
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(UIView())
            stack.addArrangedSubview(valueLabel)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        
        stepsStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    
    private func configureCardioStack() {
        let titleLabel = BaseLabel("Cardio Minutes:")
        let valueLabel = BaseLabel("\(viewModel.dietLog.cardioMinutes?.description ?? "") min")
        cardioStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(UIView())
            stack.addArrangedSubview(valueLabel)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        
        cardioStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    
    private func configureCalorieStack() {
        let titleLabel = BaseLabel("Calories Consumed:")
        let valueLabel = BaseLabel("\(viewModel.dietLog.caloriesTaken?.description ?? "") kcal")
        calorieStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(UIView())
            stack.addArrangedSubview(valueLabel)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        
        calorieStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    
    private func configureProteinsStack() {
        let titleLabel = BaseLabel("Proteins:")
        let valueLabel = BaseLabel("\(viewModel.dietLog.protein?.description ?? "") g")
        proteinsStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(UIView())
            stack.addArrangedSubview(valueLabel)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        
        proteinsStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    
    private func configureCarbsStack() {
        let titleLabel = BaseLabel("Carbs:")
        let valueLabel = BaseLabel("\(viewModel.dietLog.carbs?.description ?? "") g")
        carbsStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(UIView())
            stack.addArrangedSubview(valueLabel)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        
        carbsStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    
    private func configureFatsStack() {
        let titleLabel = BaseLabel("Fats:")
        let valueLabel = BaseLabel("\(viewModel.dietLog.fat?.description ?? "") g")
        fatsStack.configureView { [weak self] stack in
            guard let self else { return }
            stack.addArrangedSubview(titleLabel)
            stack.addArrangedSubview(UIView())
            stack.addArrangedSubview(valueLabel)
            stack.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        
        fatsStack.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    
    private func configureNoteLabel() {
        noteLabel.configureView { [weak self] label in
            guard let self else { return }
            label.text = "Note:   \(viewModel.dietLog.note ?? "No additional notes.")"
            label.heightAnchor.constraint(equalToConstant: getRowHeight()).isActive = true
        }
        
        noteLabel.configureCell { cell in
            cell.backgroundColor = .secondarySystemGroupedBackground
            cell.horizontalPadding(16)
        }
    }
    
}

// MARK: - Helper Methods
extension DietLogDetailsViewController{
    private func getRowHeight() -> CGFloat {
        return view.dynamicHeight(0.036)
    }
}

// MARK: - Preview
#Preview {
    DietLogDetailsViewController(dietLog: .dummyLog4)
}

