//
//  AddWorkoutViewModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 21.10.2025.
//
final class AddWorkoutViewModel: BaseViewModel {
    var workoutDays: [WorkoutDay] = [
        .init(name: "Test", order: 1, exercises: [.dummyExercise1, .dummyExercise2, .dummyExercise3]),
        .init(name: "", order: 2, exercises: []),
        .init(name: "", order: 3, exercises: [])
    ]
    var numberOfDaysPerWeek: Int = 3
    var workoutName: String = ""
    
    private let workoutManager: WorkoutManager
    
    init( workoutManager: WorkoutManager = AppContainer.shared.workoutManager) {
        self.workoutManager = workoutManager
    }
    
    func updateNumberOfDaysPerWeek(to newValue: Int) {
        if newValue > numberOfDaysPerWeek && newValue > workoutDays.count {
            workoutDays.append(.init(name: "", order: newValue, exercises: []))
        }
        else {
            workoutDays.removeAll(where: { $0.order > newValue })
        }
        numberOfDaysPerWeek = newValue
        print("workoutDays : \(workoutDays)")
    }
    
    func updateDay(_ workoutDay: WorkoutDay) {
        workoutDays.removeAll(where: { $0.order == workoutDay.order })
        workoutDays.append(workoutDay)
        workoutDays.sort(by: { $0.order < $1.order })
    }
    
    func addExercise(_ exercise: WorkoutExercise, toDay order: Int) {
        guard let index = workoutDays.firstIndex(where: { $0.order == order }) else { return }
        workoutDays[index].exercises.append(exercise)
    }
    
    func saveWorkout() async -> Bool {
        let workout = WorkoutProgram(name: workoutName, days: workoutDays)
        let response = await workoutManager.addWorkout(workout)
        return response
    }
}
