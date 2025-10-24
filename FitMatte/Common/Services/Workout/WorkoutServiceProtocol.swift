//
//  WorkoutServiceProtocol.swift
//  FitMatte
//
//  Created by Emre Simsek on 21.10.2025.
//

protocol WorkoutServiceProtocol {
    func addProgram(_ program: WorkoutProgram, for userId: String) async throws
    func updateProgram(_ program: WorkoutProgram, for userId: String) async throws
    func fetchPrograms(for userId: String) async throws -> [WorkoutProgram]
    func deleteProgram(_ programId: String, for userId: String) async throws
    func saveWorkoutLog(_ log: WorkoutLog, for userId: String) async throws
    func fetchWorkoutLogs(for userId: String) async throws -> [WorkoutLog]
    func deleteLog(_ log: WorkoutLog, for userId: String) async throws
}
