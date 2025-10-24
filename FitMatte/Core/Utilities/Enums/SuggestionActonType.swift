//
//  SuggestionActonType.swift
//  FitMatte
//
//  Created by Emre Simsek on 24.10.2025.
//
enum SuggestionActionType: String, CaseIterable {
    case setStepGoal
    case setCalorieGoal
    case setDietPlan
    case setWorkoutProgram

    func perform(with value: SuggestionActionValue) {
        guard let user = userSessionManager.currentUser else { return }

        switch self {
        case .setStepGoal:
            if case let .int(stepGoal) = value {
                var updatedUser = user
                updatedUser.stepGoal = stepGoal
                Task {
                    await userSessionManager.updateUser(updatedUser)
                }
            }
        case .setCalorieGoal:
            if case let .int(calorieGoal) = value {
                var updatedUser = user
                updatedUser.calorieGoal = calorieGoal
                Task {
                    await userSessionManager.updateUser(updatedUser)
                }
            }
        case .setDietPlan:
            if case let .diet(dietModel) = value {
                Task {
                    await userDietManager.addDietPlan(dietModel)
                }
            }
        case .setWorkoutProgram:
            if case let .workout(workoutProgram) = value {
                Task {
                    await userWorkoutManager.addWorkout(workoutProgram)
                }
            }
        }
    }

    private var userSessionManager: UserSessionManager {
        AppContainer.shared.userSessionManager
    }

    private var userDietManager: DietManager {
        AppContainer.shared.dietManager
    }

    private var userWorkoutManager: WorkoutManager {
        AppContainer.shared.workoutManager
    }
}

