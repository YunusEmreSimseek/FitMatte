//
//  WorkoutLog.swift
//  FitMatte
//
//  Created by Emre Simsek on 21.10.2025.
//
import Foundation
import FirebaseFirestore

struct WorkoutLog: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var date: Date
    var programId: String?
    var programName: String?
    var dayId: String?
    var dayName: String?
    var exercises: [WorkoutExercise]
}

extension WorkoutLog {
    static let dummyLog = WorkoutLog(
        id: "dummyLog",
        date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 5))!,
        programId: "dummyProgram1",
        programName: "Güç Antrenmanı",
        dayId: "dummyDay1",
        dayName: "İtiş Günü",
        exercises: [
            WorkoutExercise.dummyExercise1,
            WorkoutExercise.dummyExercise2,
        ]
    )
    static let dummyLog2 = WorkoutLog(
        id: "dummyLog2",
        date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 6))!,
        programId: "dummyProgram1",
        programName: "Güç Antrenmanı",
        dayId: "dummyDay2",
        dayName: "Çekiş Günü",
        exercises: [
            WorkoutExercise.dummyExercise3,
        ]
    )
    static let dummyLog3 = WorkoutLog(
        id: "dummyLog3",
        date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 7))!,
        programId: "dummyProgram2",
        programName: "Hipertrofi Antrenmanı",
        dayId: "dummyDay1",
        dayName: "İtiş Günü",
        exercises: [
            WorkoutExercise.dummyExercise1,
            WorkoutExercise.dummyExercise2,
        ]
    )
    static let dummyLog4 = WorkoutLog(
        id: "dummyLog4",
        date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 8))!,
        programId: "dummyProgram2",
        programName: "Hipertrofi Antrenmanı",
        dayId: "dummyDay2",
        dayName: "Çekiş Günü",
        exercises: [
            WorkoutExercise.dummyExercise3,
        ]
    )
    static let dummyLogs: [WorkoutLog] = [
        dummyLog,
        dummyLog2,
        dummyLog3,
        dummyLog4,
    ]

    func calculateTotalSets() -> Int {
        exercises.reduce(0) { $0 + $1.sets }
    }
}
