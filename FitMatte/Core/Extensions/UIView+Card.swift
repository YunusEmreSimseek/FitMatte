//
//  UIView+Card.swift
//  FitMatte
//
//  Created by Emre Simsek on 16.10.2025.
//
import UIKit

extension UIView {
    func card(radius: CGFloat = 12, bgColor: UIColor = .secondarySystemGroupedBackground) {
        self.layer.applyShadow(radius)
        self.backgroundColor = bgColor
    }
}
