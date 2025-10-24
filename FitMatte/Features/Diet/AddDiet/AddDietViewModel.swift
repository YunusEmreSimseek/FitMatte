//
//  AddDietViewModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 21.10.2025.
//
import Foundation

final class AddDietViewModel: BaseViewModel {
    var dietDuration: Int = 30
    var loseWeightGoal: Double = 5
    var goalWeight: Double = 70
    var stepCountGoal: Int = 10000
    var calorieLimitGoal: Int = 2200
    var proteinGoal: Int = 150
    
    private let dietManager: DietManager
    
    init(dietManager: DietManager = AppContainer.shared.dietManager){
        self.dietManager = dietManager
    }
    
    func saveDiet() async {
        let dietPlan = DietModel(
            startDate: Date(), durationInDays: dietDuration, weightLossGoalKg: loseWeightGoal, targetWeight: goalWeight, dailyStepGoal: stepCountGoal, dailyCalorieLimit: calorieLimitGoal, dailyProteinGoal: proteinGoal
        )
        setState(.loading)
        defer { setState(.idle) }
        await dietManager.addDietPlan(dietPlan)
    }
}
