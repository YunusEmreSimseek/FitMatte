//
//  UserModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 17.10.2025.
//
import FirebaseAuth
import FirebaseFirestore
import Foundation

struct UserModel: Identifiable, Equatable, Codable, Hashable {
    @DocumentID var id: String?
    var email: String
    var password: String
    var name: String
    var gender: Gender?
    var birthDate: Date?
    var height: Int?
    var weight: Int?
    var goals: [Goal]?
    var stepGoal: Int?
    var calorieGoal: Int?
    var sleepGoal: Int?
    var createdAt: Date?
    var fitnessLevel: FitnessLevel?
    var isPremium: Bool?
    
    
}

extension UserModel {
    static let dummyUser = UserModel(
        email: "dummy@dummy.com",
        password: "dummy",
        name: "Dummy User",
        gender: .male,
        birthDate: Calendar.current.date(from: DateComponents(year: 2001, month: 10, day: 11)),
        height: 180,
        weight: 75,
//        goals: ["Lose weight", "Build muscle"],
        goals: [.loseWeight, .gainMuscles],
        stepGoal: 10000,
        calorieGoal: 500,
        sleepGoal: 8,
        createdAt: Date(),
        fitnessLevel: .beginner
    )

    func toAIUserModel() -> AIUserModel {
        .init(
            name: name,
            gender: gender,
            age: birthDate?.calculateAge(),
            height: height,
            weight: weight,
            goals: goals,
            fitnessLevel: fitnessLevel,
            stepGoal: stepGoal
        )
    }
}
