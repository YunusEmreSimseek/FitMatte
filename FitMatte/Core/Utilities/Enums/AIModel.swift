//
//  AIModel.swift
//  FitMatte
//
//  Created by Emre Simsek on 20.10.2025.
//
import Foundation

enum AIModel: String, Codable, CaseIterable, Identifiable {
    case mistralAI
    case openAI
    
    var id: String { rawValue }

        var displayName: String {
            switch self {
            case .openAI: return "Open AI"
            case .mistralAI: return "Mistral AI"
            }
        }

        var icon: String {
            switch self {
            case .openAI: return "circle.grid.cross"
            case .mistralAI: return "wind"
            }
        }
}
