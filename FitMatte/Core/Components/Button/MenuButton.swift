//
//  MenuButton.swift
//  FitMatte
//
//  Created by Emre Simsek on 20.10.2025.
//
import UIKit

final class MenuButton: UIButton {
    private let padding = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
    
    convenience init(_ options: [String]) {
        self.init(type: .system)
        self.configure()
        self.configureSelfMenu(options)
    }
    
    private func configureSelfMenu(_ options: [String]) {
        let menuActions = options.map { option in
            UIAction(title: option, handler: { _ in
                self.setTitle(option, for: .normal)
            })
        }
        self.menu = UIMenu(children: menuActions)
    }
        
//        self.setTitle(options.first, for: .normal)
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        var cfg = UIButton.Configuration.glass()
        cfg.contentInsets = self.padding
        cfg.cornerStyle = .large
        self.configuration = cfg
        self.showsMenuAsPrimaryAction = true
        self.changesSelectionAsPrimaryAction = true
    }
}
