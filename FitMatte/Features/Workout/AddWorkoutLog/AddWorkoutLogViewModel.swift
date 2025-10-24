//
//  AddWorkoutLogViewModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 23.10.2025.
//
import Foundation

final class AddWorkoutLogViewModel: BaseViewModel {
    var selectedDate: Date = Date()
    var selectedWorkoutProgram: WorkoutProgram?
    var selectedWorkoutDay: WorkoutDay?
    var exercises: [WorkoutExercise] = []
    var workoutProgramList: [WorkoutProgram] = []
        
    let workoutManager: WorkoutManager
    
    init(workoutManager: WorkoutManager = AppContainer.shared.workoutManager) {
        self.workoutManager = workoutManager
        if AppMode.isPreview {
            self.workoutManager.workoutPrograms = [ .dummyProgram1, .dummyProgram2]
//            selectedWorkoutProgram = .dummyProgram1
//            selectedWorkoutDay = .dummyDay1
//            exercises = WorkoutDay.dummyDay1.exercises
        }
    }
    
    func updateExercise(_ exercise: WorkoutExercise) {
        guard let index = exercises.firstIndex(where: { $0.id == exercise.id }) else { return}
        exercises[index] = exercise
    }
    
    func saveWorkoutLog() async -> Bool {
        guard let selectedWorkoutProgram,
              let selectedWorkoutDay else { return false }
                
        let workoutLog = WorkoutLog(
            date: selectedDate,
            programId: selectedWorkoutProgram.id ?? "",
            programName: selectedWorkoutProgram.name,
            dayId: selectedWorkoutDay.id,
            dayName: selectedWorkoutDay.name,
            exercises: exercises)
        let response = await workoutManager.saveWorkoutLog(workoutLog)
        return response
    }
        
}
