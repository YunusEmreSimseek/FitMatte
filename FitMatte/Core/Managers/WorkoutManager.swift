//
//  WorkoutManager.swift
//  FitMatte
//
//  Created by Emre Simsek on 22.10.2025.
//
import Combine

final class WorkoutManager {
    @Published var workoutLogs: [WorkoutLog] = []
    @Published var workoutPrograms: [WorkoutProgram] = []
    private let workoutService: WorkoutServiceProtocol
    
    init(workoutService: WorkoutServiceProtocol = AppContainer.shared.workoutService) {
        self.workoutService = workoutService
        if AppMode.isPreview {
            workoutPrograms = WorkoutProgram.dummyPrograms
            workoutLogs = WorkoutLog.dummyLogs
        }
    }
    
    func loadManager() async {
        await fetchWorkoutPrograms()
        await fetchWorkoutLogs()
    }
    
    func addWorkout(_ workout: WorkoutProgram) async -> Bool {
        guard let uid = AppContainer.shared.userSessionManager.currentUser?.id else { return false }
        do {
            try await workoutService.addProgram(workout, for: uid)
            await fetchWorkoutPrograms()
            return true
        }
        catch {
            print("Error adding workout program: \(error)")
            return false
        }
     }
    
    func saveWorkoutLog(_ log: WorkoutLog) async -> Bool {
        guard let uid = AppContainer.shared.userSessionManager.currentUser?.id else { return false }
        do {
            try await workoutService.saveWorkoutLog(log, for: uid)
            await fetchWorkoutLogs()
            return true
        } catch  {
            print("Error adding workout log: \(error)")
            return false
        }
            
    }
    
    func deleteWorkoutProgram(_ workoutProgramId: String) async -> Bool {
        guard let uid = AppContainer.shared.userSessionManager.currentUser?.id else { return false }
        do {
            try await workoutService.deleteProgram(workoutProgramId, for:uid )
            await fetchWorkoutPrograms()
            return true
        } catch  {
            print("Error deleting workout program: \(error)")
            return false
        }
    }
        
}

extension WorkoutManager {
    private func fetchWorkoutPrograms() async {
        if AppMode.isPreview {
            workoutPrograms = WorkoutProgram.dummyPrograms
        }
        else {
            guard let uid = AppContainer.shared.userSessionManager.currentUser?.id else { return }
            guard let response = try? await workoutService.fetchPrograms(for: uid)
            else { return }
            workoutPrograms = response
        }
    }
    
    private func fetchWorkoutLogs() async {
        if AppMode.isPreview {
            workoutLogs = WorkoutLog.dummyLogs
        }
        else {
            guard let uid = AppContainer.shared.userSessionManager.currentUser?.id else { return }
            guard let response = try? await workoutService.fetchWorkoutLogs(for: uid)
            else { return }
            workoutLogs = response
        }
    }
}
