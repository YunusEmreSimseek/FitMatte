//
//  HomeInformationCard.swift
//  FitMatte
//
//  Created by Emre Simsek on 15.10.2025.
//
import UIKit

class CardView: UIView {
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
        
    let titleLabel: BaseLabel = {
        let label = BaseLabel()
        label.font = ThemeFont.defaultTheme.semiBoldText
        label.textColor = .systemGray
        return label
    }()
        
    let subtitleLabel: BaseLabel = {
        let label = BaseLabel()
        label.font = ThemeFont.defaultTheme.boldText
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
        
    private func setupView() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
            
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(subtitleLabel)
        addSubview(contentStackView)
            
        NSLayoutConstraint.activate([
//            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
//            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
        ])
    }
        
    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
