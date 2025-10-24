//
//  DietModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 21.10.2025.
//

import FirebaseFirestore

struct DietModel: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    let startDate: Date
    let durationInDays: Int
    let weightLossGoalKg: Double
    let targetWeight: Double

    let dailyStepGoal: Int
    let dailyCalorieLimit: Int
    let dailyProteinGoal: Int

    var endDate: Date {
        Calendar.current.date(byAdding: .day, value: durationInDays, to: startDate) ?? startDate
    }
}

struct PartialDietModel: Decodable {
    let durationInDays: Int
    let weightLossGoalKg: Double
    let targetWeight: Double
    let dailyStepGoal: Int
    let dailyCalorieLimit: Int
    let dailyProteinGoal: Int
}

extension DietModel {
    static let dummyDiet = DietModel(
        startDate: Date(),
        durationInDays: 30,
        weightLossGoalKg: 5.0,
        targetWeight: 70.0,
        dailyStepGoal: 10000,
        dailyCalorieLimit: 2000,
        dailyProteinGoal: 150
    )
}
