//
//  GenericCardView.swift
//  FitMatte
//
//  Created by Emre Simsek on 15.10.2025.
//
import UIKit

final class GenericCardView: UIView {
    private var contentView: UIView?

    private let contentPadding: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCardStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCardStyle()
    }

    private func setupCardStyle() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 10
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if layer.shadowPath == nil || layer.shadowPath?.boundingBox != bounds {
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        }
    }

    func setContentView(_ view: UIView) {
        if let existingContentView = contentView {
            existingContentView.removeFromSuperview()
        }

        contentView = view
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentPadding.left),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentPadding.right),
            view.topAnchor.constraint(equalTo: topAnchor, constant: contentPadding.top),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentPadding.bottom),
        ])
    }
}
