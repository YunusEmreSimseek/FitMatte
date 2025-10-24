//
//  TextButton.swift
//  FitMatte
//
//  Created by Emre Simsek on 23.10.2025.
//
import UIKit

final class TextButton: UIButton {
    
    convenience init(_ text: String, _ font: UIFont = ThemeFont.defaultTheme.text) {
        self.init(frame: .zero)
        configure(text, font)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure("", ThemeFont.defaultTheme.text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(_ text: String, _ font: UIFont) {
        self.translatesAutoresizingMaskIntoConstraints = false
        var cfg = UIButton.Configuration.plain()
        cfg.font(font)
        cfg.title = text
        configuration = cfg
    }
}

extension TextButton {
    static let Save: TextButton = {
        let button = TextButton("Save")
        return button
    }()
    
    static let Cancel: TextButton = {
        let button = TextButton("Cancel")
        return button
    }()
}
