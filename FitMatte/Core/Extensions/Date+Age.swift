//
//  Date+Age.swift
//  FitMatte
//
//  Created by Emre Simsek on 17.10.2025.
//
import Foundation

extension Date {
    func calculateAge() -> Int {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year], from: self, to: now)
        return components.year ?? 0
    }
}
