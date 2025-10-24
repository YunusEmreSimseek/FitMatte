//
//  CancelButton.swift
//  FitMatte
//
//  Created by Emre Simsek on 22.10.2025.
//
import UIKit

final class CancelButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        var cfg = UIButton.Configuration.plain()
        cfg.title = "Cancel"
        cfg.font(ThemeFont.defaultTheme.text)
        self.configuration = cfg
    }
}
