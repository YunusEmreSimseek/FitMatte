//
//  WorkoutExercise.swift
//  FitMatte
//
//  Created by Emre Simsek on 21.10.2025.
//
import Foundation

struct WorkoutExercise: Codable, Identifiable, Hashable, Equatable {
    var id: String = UUID().uuidString
    var name: String
    var sets: Int
    var reps: Int
    var weight: Double
    var notes: String?
}

extension WorkoutExercise {
    static let dummyExercise1 = WorkoutExercise(
        id: "dummyExercise1",
        name: "Bench Press",
        sets: 4,
        reps: 8,
        weight: 70.0,
        notes: "Dumbbell kullan"
    )
    static let dummyExercise2 = WorkoutExercise(
        id: "dummyExercise2",
        name: "Squat",
        sets: 4,
        reps: 10,
        weight: 80.0,
        notes: nil
    )
    static let dummyExercise3 = WorkoutExercise(
        id: "dummyExercise3",
        name: "Deadlift",
        sets: 3,
        reps: 6,
        weight: 100.0,
        notes: "Forma dikkat et"
    )
    static let dummyExercises = [
        dummyExercise1,
        dummyExercise2,
        dummyExercise3,
    ]
}
