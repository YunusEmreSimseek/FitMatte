//
//  AddDietLogViewModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 23.10.2025.
//
import Foundation

final class AddDietLogViewModel: BaseViewModel {
    var selectedDate: Date = .init()
    var stepsNumber: Int = 0
    var cardioMinutes: Int = 0
    var caloriesConsumed: Int = 0
    var proteinConsumed: Int = 0
    var carbsConsumed: Int = 0
    var fatsConsumed: Int = 0
    var note: String = ""
    
    let dietManager: DietManager
    let healthKitManager: HealthKitManager
    
    init(
        dietManager: DietManager = AppContainer.shared.dietManager,
        healthKitManager: HealthKitManager = AppContainer.shared.healthKitManager
    ) {
        self.dietManager = dietManager
        self.healthKitManager = healthKitManager
        self.stepsNumber = Int(healthKitManager.stepCount)
        if AppMode.isPreview {
            self.stepsNumber = 1773
        }
    }
    
    func saveDietLog() async {
        let date = DateFormatter.localizedString(from: selectedDate, dateStyle: .short, timeStyle: .none)
            .replacingOccurrences(of: "/", with: "-")
        let log = DailyDietModel(
            id: date,
            dateString: date,
            stepCount: stepsNumber,
            cardioMinutes: cardioMinutes,
            caloriesTaken: caloriesConsumed,
            protein: proteinConsumed,
            carbs: carbsConsumed,
            fat: fatsConsumed,
            weight: nil)
        await dietManager.addDailyDietLog(log)
    }
}
