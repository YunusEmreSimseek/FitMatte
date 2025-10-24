//
//  UIView+Spacer.swift
//  FitMatte
//
//  Created by Emre Simsek on 16.10.2025.
//
import UIKit

extension UIView {
    static func vSpacer(_ height: CGFloat) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
    }

    static func hSpacer(_ width: CGFloat) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        return view
    }
}
