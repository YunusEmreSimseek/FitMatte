//
//  CALayer+Shadow.swift
//  FitMatte
//
//  Created by Emre Simsek on 16.10.2025.
//
import UIKit

extension CALayer {
    func applyShadow(_ radius: CGFloat = 16) {
        self.cornerRadius = radius
        self.shadowColor = UIColor.systemGray.cgColor
        self.shadowOpacity = 0.25
        self.shadowOffset = .zero
        self.shadowRadius = 2
        self.masksToBounds = false
    }
}
