//
//  UIView+Size.swift
//  FitMatte
//
//  Created by Emre Simsek on 22.10.2025.
//
import UIKit

extension UIView {
    func dynamicHeight(_ multiplier: CGFloat) -> CGFloat {
        guard let windowScene = window?.windowScene else {
            return UIScreen.main.bounds.height * multiplier
        }
        let currentScreen = windowScene.screen
        let screenHeight = currentScreen.bounds.height
        return screenHeight * multiplier
    }

    func dynamicWidth(_ multiplier: CGFloat) -> CGFloat {
        guard let windowScene = window?.windowScene else {
            return UIScreen.main.bounds.height * multiplier
        }
        let currentScreen = windowScene.screen
        let screenWidth = currentScreen.bounds.width
        return screenWidth * multiplier
    }
}
