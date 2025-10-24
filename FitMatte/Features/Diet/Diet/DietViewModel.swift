//
//  DietViewModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 21.10.2025.
//
import Foundation

final class DietViewModel: BaseViewModel {
    let dietManager: DietManager

    init(dietManager: DietManager = AppContainer.shared.dietManager) {
        self.dietManager = dietManager
    }

    func deleteDailyDietLog(_ log: DailyDietModel) async {
        setState(.loading)
        defer { setState(.idle) }
        await dietManager.deleteDailyDietLog(log)
    }
}
