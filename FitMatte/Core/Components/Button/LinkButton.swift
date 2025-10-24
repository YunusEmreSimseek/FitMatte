//
//  LinkButton.swift
//  FitMatte
//
//  Created by Emre Simsek on 19.10.2025.
//
import UIKit

final class LinkButton: UIButton {
    init(_ size: LinkButtonSize = .medium){
        super.init(frame: .zero)
        configure(size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(_ size: LinkButtonSize){
        var cfg = UIButton.Configuration.plain()
        cfg.image = .init(systemName: "chevron.right")
        cfg.preferredSymbolConfigurationForImage = .init(font: .systemFont(ofSize: size.rawValue))
        cfg.contentInsets = .zero
        self.configuration = cfg
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

enum LinkButtonSize: CGFloat {
    case small = 12
    case medium = 16
    case large = 20
}
    

