//
//  DietLogDetailsViewModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 24.10.2025.
//
final class DietLogDetailsViewModel: BaseViewModel {
    let dietLog: DailyDietModel
    init(dietLog: DailyDietModel) {
        self.dietLog = dietLog
    }
}
