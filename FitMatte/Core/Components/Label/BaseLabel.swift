//
//  BaseLabel.swift
//  FitMatte
//
//  Created by Emre Simsek on 15.10.2025.
//
import UIKit

final class BaseLabel: UILabel {
    
    convenience init(_ text: String) {
        self.init(frame: .zero)
        self.text = text
    }
    
    convenience init(_ text: String, _ font: UIFont) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func baseConfiguration(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = ThemeFont.defaultTheme.text
        self.numberOfLines = 0
        
    }
}
//
//extension BaseLabel: DefaultInitializable {
//    static let defaultValue = BaseLabel()
//}
