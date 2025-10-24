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
}


