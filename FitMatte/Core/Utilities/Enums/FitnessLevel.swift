//
//  FitnessLevel.swift
//  FitMatte
//
//  Created by Emre Simsek on 17.10.2025.
//
enum FitnessLevel: String, CaseIterable, Identifiable, Hashable, Pickable, Codable {
    case beginner
    case intermediate
    case advanced

    var id: String { rawValue }

    var title: String {
        switch self {
        case .beginner: "beginner"
        case .intermediate: "intermediate"
        case .advanced: "advanced"
        }
    }

    var description: String {
        switch self {
        case .beginner: "Suitable for those new to fitness or returning after a long break."
        case .intermediate: "For individuals with some experience in fitness routines."
        case .advanced: "Designed for seasoned athletes or those with extensive training backgrounds."
        }
    }

    var tag: Int {
        switch self {
        case .beginner: 1
        case .intermediate: 2
        case .advanced: 3
        }
    }
}

