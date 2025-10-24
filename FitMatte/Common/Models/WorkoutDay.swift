//
//  WorkoutDay.swift
//  FitMatte
//
//  Created by Emre Simsek on 21.10.2025.
//
import Foundation

struct WorkoutDay: Codable, Identifiable, Hashable, Equatable {
    var id: String = UUID().uuidString
    var name: String
    var order: Int
    var exercises: [WorkoutExercise]
    
    mutating func update(_ workoutDay: WorkoutDay) {
        self.name = workoutDay.name
        self.order = workoutDay.order
        self.exercises = workoutDay.exercises
    }
}

struct PartialDay: Decodable {
    var name: String
    var order: Int
    var exercises: [PartialExercise]
}

extension WorkoutDay {
    static let dummyDay1 = WorkoutDay(
        id: "dummyDay1",
        name: "İtiş Günü",
        order: 1,
        exercises: [
            WorkoutExercise.dummyExercise1,
            WorkoutExercise.dummyExercise2,
        ]
    )
    static let dummyDay2 = WorkoutDay(
        id: "dummyDay2",
        name: "Çekiş Günü",
        order: 2,
        exercises: [
            WorkoutExercise.dummyExercise3,
        ]
    )
    static let dummyDays = [dummyDay1, dummyDay2]
}
