//
//  BaseButton.swift
//  FitMatte
//
//  Created by Emre Simsek on 15.10.2025.
//
import UIKit

final class BaseButton: UIButton {
    convenience init(_ text: String) {
        self.init(frame: .zero)
        self.setTitle(text, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseConfiguration()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ text: String) {
        self.configuration?.title = text
        self.configuration?.font(ThemeFont.defaultTheme.semiBoldText)
    }
    
    private func baseConfiguration() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel?.font = ThemeFont.defaultTheme.semiBoldText
        var cfg = UIButton.Configuration.glass()
        cfg.background.backgroundColor = .systemBlue
        cfg.cornerStyle = .small
        self.configuration = cfg
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
    }
}
