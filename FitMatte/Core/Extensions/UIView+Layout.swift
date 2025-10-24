//
//  UIView+Layout.swift
//  FitMatte
//
//  Created by Emre Simsek on 17.10.2025.
//
import UIKit

extension UIView {
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: padding.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding.left),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding.bottom),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding.right)
        ])
    }
    
    func fillSuperview(padding: CGFloat) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: padding),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding)
        ])
    }
    
    func fillHorizontallySuperview(padding: CGFloat = .zero) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding)
        ])
    }
    
    func fillVerticallySuperview(padding: CGFloat = .zero) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: padding),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding)
        ])
    }
}
    
