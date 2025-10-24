//
//  MistralModels.swift
//  FitMatte
//
//  Created by Emre Simsek on 17.10.2025.
//
struct AIUserModel: Encodable {
    let name: String?
    let gender: Gender?
    let age: Int?
    let height: Int?
    let weight: Int?
    let goals: [Goal]?
    let fitnessLevel: FitnessLevel?
    let stepGoal: Int?
}

extension AIUserModel {
    static let dummyAIUserModel: AIUserModel = .init(
        name: "Emre Şimşek", gender: .male, age: 23, height: 175, weight: 80, goals: [.gainMuscles, .getFitter], fitnessLevel: .advanced, stepGoal: 10000
    )

    func toPrompt() -> String {
        let nameString: String = name ?? "unknown"
        let genderString: String = gender.map(\.rawValue) ?? "unknown"
        let ageString: String = age.map(String.init) ?? "unknown"
        let heightString: String = height.map(String.init) ?? "unknown"
        let weightString: String = weight.map(String.init) ?? "unknown"
        let goalsString: String = goals?.map(\.rawValue).joined(separator: ", ") ?? "unknown"
        let fitnessLevelString: String = fitnessLevel?.rawValue ?? "unknown"
        let stepGoalString: String = stepGoal.map(String.init) ?? "unknown"

        return """
        - Name: \(nameString)
        - Gender: \(genderString)
        - Age: \(ageString)
        - Height: \(heightString) cm
        - Weight: \(weightString) kg
        - Goals: \(goalsString)
        - Fitness Level: \(fitnessLevelString)
        - Step Goal: \(stepGoalString) steps
        """
    }
}

struct MistralAIRequest: Encodable {
    let prompt: String
}

struct MistralAIResponse: Decodable {
    let answer: String
}
