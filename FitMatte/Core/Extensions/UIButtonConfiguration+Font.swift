//
//  UIButtonConfiguration+Font.swift
//  FitMatte
//
//  Created by Emre Simsek on 15.10.2025.
//
import UIKit

extension UIButton.Configuration {
    mutating func font(_ font: UIFont) {
        var newAttributedTitle = self.attributedTitle ?? AttributedString(self.title ?? "")
        newAttributedTitle.font = font
        self.attributedTitle = newAttributedTitle
    }
}
