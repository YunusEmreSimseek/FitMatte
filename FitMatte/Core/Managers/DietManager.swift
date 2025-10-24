//
//  DietManager.swift
//  FitMatte
//
//  Created by Emre Simsek on 22.10.2025.
//
import Combine
import Foundation

final class DietManager {
    @Published private(set) var dietPlan: DietModel?
    @Published private(set) var dailyLogs: [DailyDietModel] = []
    var averageCalories: Int = 0
    var averageSteps: Int = 0
    var remainingDays: Int = 0
    private let dietService: DietServiceProtocol
    
    init(dietService: DietServiceProtocol = AppContainer.shared.dietService) {
        self.dietService = dietService
        if AppMode.isPreview {
            dietPlan = DietModel.dummyDiet
            dailyLogs = DailyDietModel.dummyLogs
            calculateRemainingDays()
            calculateAverages()
        }
    }
    
    func loadManager() async {
        await fetchDietPlan()
        await fetchDailyLogs()
    }
    
    func addDietPlan(_ dietPlan: DietModel) async {
        guard let uid = AppContainer.shared.userSessionManager.currentUser?.id else { return }
        await dietService.saveDiet(dietPlan, for: uid)
        await fetchDietPlan()
    }
    
    func addDailyDietLog(_ log: DailyDietModel) async {
        guard let uid = AppContainer.shared.userSessionManager.currentUser?.id else { return }
        await dietService.saveOrUpdateDailyDietLog(log, for: uid)
        await fetchDailyLogs()
    }
    
    func deleteDailyDietLog(_ log: DailyDietModel) async {
        guard let uid = AppContainer.shared.userSessionManager.currentUser?.id else { return }
        await dietService.deleteDailyDietLog(for: uid, dateString: log.dateString)
        await fetchDailyLogs()
    }
}

extension DietManager {
    private func fetchDietPlan() async {
        if AppMode.isPreview {
            dietPlan = DietModel.dummyDiet
        }
        else {
            guard let uid = AppContainer.shared.userSessionManager.currentUser?.id else { return }
            guard let fetchedDiet = await dietService.fetchDiet(for: uid)
            else { return }
            dietPlan = fetchedDiet
        }
        calculateRemainingDays()
    }
    
    private func fetchDailyLogs() async {
        if AppMode.isPreview {
            dailyLogs = DailyDietModel.dummyLogs
        }
        else {
            guard let uid = AppContainer.shared.userSessionManager.currentUser?.id else { return }
            let fetchedLogs = await dietService.fetchDailyDietLogs(for: uid)
            dailyLogs = fetchedLogs
        }
        calculateAverages()
    }
    
    private func calculateRemainingDays() {
        guard let dietPlan else { return }
        guard dietPlan.endDate > Date() else {
            return
        }
        let calendar = Calendar.current
        let componenets = calendar.dateComponents([.day], from: Date(), to: dietPlan.endDate)
        remainingDays = componenets.day ?? 0
    }
    
    private func calculateAverages() {
        guard !dailyLogs.isEmpty else { return }
        var totalCalories = 0
        var totalSteps = 0
        for log in dailyLogs {
            totalCalories += log.caloriesTaken ?? 0
            totalSteps += log.stepCount ?? 0
        }
        averageCalories = totalCalories / dailyLogs.count
        averageSteps = totalSteps / dailyLogs.count
    }
}
