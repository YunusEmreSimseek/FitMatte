//
//  DietServiceProtocol.swift
//  FitMatte
//
//  Created by Emre Simsek on 21.10.2025.
//
protocol DietServiceProtocol {
    func saveDiet(_ diet: DietModel, for userId: String) async
    func fetchDiet(for userId: String) async -> DietModel?
    func deleteDiet(for userId: String) async
    func saveOrUpdateDailyDietLog(_ log: DailyDietModel, for userId: String) async
    func fetchDailyDietLogs(for userId: String, lastDays: Int) async -> [DailyDietModel]
    func deleteDailyDietLog(for userId: String, dateString: String) async
}

extension DietServiceProtocol {
    func fetchDailyDietLogs(for userId: String, lastDays: Int = 7) async -> [DailyDietModel] {
        await fetchDailyDietLogs(for: userId, lastDays: lastDays)
    }
}
    
