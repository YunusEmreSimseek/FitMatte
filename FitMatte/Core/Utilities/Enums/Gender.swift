//
//  Gender.swift
//  FitMatte
//
//  Created by Emre Simsek on 17.10.2025.
//

enum Gender: String, Codable, Identifiable, CaseIterable {
    case male
    case female

    var id: String { rawValue }

    var title: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        }
    }
}
