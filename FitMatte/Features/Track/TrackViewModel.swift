//
//  TrackViewModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 14.10.2025.
//
import UIKit

final class TrackViewModel: BaseViewModel {
    var currentPage: TrackViewTab = .diets
}

extension TrackViewModel {
    func updateCurrentPage(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        currentPage = TrackViewTab(rawValue: selectedIndex) ?? .workouts
    }
}

enum TrackViewTab: Int, CaseIterable {
    case workouts
    case diets

    var title: String {
        switch self {
        case .workouts:
            "Workouts"
        case .diets:
            "Diets"
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .workouts:
            WorkoutViewController()
        case .diets:
            DietViewController()
        }
    }
    
    var addButtonMenuItems: [TrackViewAddButtonMenuItem] {
        switch self {
        case .workouts:
            [.addWorkout, .addWorkoutLog]
        case .diets:
            [.addDiet, .addDietLog]
        }
    }
        
    
    var addButtonTarget: UIViewController {
        switch self {
        case .workouts:
            AddWorkoutViewController()
        case .diets:
            AddDietViewController()
        }
    }
}

enum TrackViewAddButtonMenuItem: String {
    case addWorkout = "Add Workout"
    case addWorkoutLog = "Add Workout Log"
    case addDiet = "Add Diet"
    case addDietLog = "Add Diet Log"
    
    var target: UIViewController {
        switch self {
        case .addWorkout:
            AddWorkoutViewController()
        case .addWorkoutLog:
            AddWorkoutLogViewController()
        case .addDiet:
            AddDietViewController()
        case .addDietLog:
            AddDietLogViewController()
        }
    }
        
}
