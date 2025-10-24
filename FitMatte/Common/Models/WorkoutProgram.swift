//
//  WorkoutProgram.swift
//  FitMatte
//
//  Created by Emre Simsek on 21.10.2025.
//
import FirebaseFirestore
import Foundation

struct WorkoutProgram: Identifiable, Codable, Hashable, Equatable {
    @DocumentID var id: String?
    var name: String
    var days: [WorkoutDay]
    var createdAt: Date = .init()
}

struct PartialWorkoutProgram: Decodable {
    var name: String
    var days: [PartialDay]
}

extension WorkoutProgram {
    static let dummyProgram1 = WorkoutProgram(
        id: "dummyProgram1",
        name: "Güç Antrenmanı",
        days: [
            WorkoutDay.dummyDay1,
            WorkoutDay.dummyDay2,
        ]
    )
    static let dummyProgram2 = WorkoutProgram(
        id: "dummyProgram2",
        name: "Hipertrofi Antrenmanı",
        days: [
            WorkoutDay.dummyDay1,
            WorkoutDay.dummyDay2,
        ]
    )
    static let dummyProgram3 = WorkoutProgram(
        id: "dummyProgram3",
        name: "Yağ Yakım Antrenmanı",
        days: [
            WorkoutDay.dummyDay1,
            WorkoutDay.dummyDay2,
        ]
    )
    static let dummyPrograms: [WorkoutProgram] = [
        dummyProgram1,
        dummyProgram2,
        dummyProgram3,
    ]
}
