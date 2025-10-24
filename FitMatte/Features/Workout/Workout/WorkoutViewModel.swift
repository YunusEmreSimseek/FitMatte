//
//  WorkoutViewModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 21.10.2025.
//
final class WorkoutViewModel: BaseViewModel {
    let workoutManager: WorkoutManager
    
    init(workoutManager: WorkoutManager = AppContainer.shared.workoutManager) {
        self.workoutManager = workoutManager
    }
    
    func deleteWorkoutProgram(_ workoutProgramId: String) async -> Bool {
        setState(.loading)
        defer { setState(.idle) }
        let response = await workoutManager.deleteWorkoutProgram(workoutProgramId)
        return response
    }
}


