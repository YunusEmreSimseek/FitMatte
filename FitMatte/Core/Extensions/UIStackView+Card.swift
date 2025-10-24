//
//  UIStackView+Card.swift
//  FitMatte
//
//  Created by Emre Simsek on 16.10.2025.
//
import UIKit

extension UIStackView {
    func toCard(_ radius: CGFloat = 16, bgColor: UIColor = .secondarySystemGroupedBackground, padding: CGFloat = 16) {
        self.layer.applyShadow(radius)
        self.backgroundColor = bgColor
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
}
