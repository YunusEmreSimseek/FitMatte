//
//  SuggestionActionValue.swift
//  FitMatte
//
//  Created by Emre Simsek on 24.10.2025.
//
import Foundation

enum SuggestionActionValue: Decodable {
    case int(Int)
    case diet(DietModel)
    case workout(WorkoutProgram)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
            return
        }

        if let dietValue = try? container.decode(PartialDietModel.self) {
            let dietModel = DietModel(
                startDate: .now,
                durationInDays: dietValue.durationInDays,
                weightLossGoalKg: dietValue.weightLossGoalKg,
                targetWeight: dietValue.targetWeight,
                dailyStepGoal: dietValue.dailyStepGoal,
                dailyCalorieLimit: dietValue.dailyCalorieLimit,
                dailyProteinGoal: dietValue.dailyProteinGoal
            )
            self = .diet(dietModel)
            return
        }

        if let workoutValue = try? container.decode(PartialWorkoutProgram.self) {
            let workoutDays = workoutValue.days.map { day in
                WorkoutDay(
                    name: day.name,
                    order: day.order,
                    exercises: day.exercises.map { exercise in
                        WorkoutExercise(
                            name: exercise.name,
                            sets: exercise.sets,
                            reps: exercise.reps,
                            weight: exercise.weight
                        )
                    }
                )
            }
            let workoutProgram = WorkoutProgram(
                name: workoutValue.name,
                days: workoutDays
            )
            self = .workout(workoutProgram)
            return
        }

        throw DecodingError.typeMismatch(
            SuggestionActionValue.self,
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Unsupported SuggestionActionValue type"
            )
        )
    }
}
