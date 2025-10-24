//
//  Goal.swift
//  FitMatte
//
//  Created by Emre Simsek on 17.10.2025.
//
enum Goal: String, CaseIterable, Identifiable, Hashable, Codable {
    case loseWeight = "lose weight"
    case getFitter = "get fitter"
    case maintainWeight = "maintain weight"
    case gainMuscles = "gain muscles"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .loseWeight: return "lose weight"
        case .getFitter: return "get fitter"
        case .maintainWeight: return "maintain weight"
        case .gainMuscles: return "gain muscles"
        }
    }

    var description: String {
        switch self {
        case .loseWeight: return "Focuses on reducing body fat and improving overall health."
        case .getFitter: return "Aims to enhance cardiovascular health and overall fitness levels."
        case .maintainWeight: return "Targets sustaining current weight while improving fitness."
        case .gainMuscles: return "Emphasizes building muscle mass and strength."
        }
    }

    var image: String {
        switch self {
        case .loseWeight: return "burn"
        case .getFitter: return "heartbeat"
        case .maintainWeight: return "balance"
        case .gainMuscles: return "dumbell"
        }
    }
}
