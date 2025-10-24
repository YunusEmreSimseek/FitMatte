//
//  BaseTextField.swift
//  FitMatte
//
//  Created by Emre Simsek on 15.10.2025.
//
import UIKit

final class BaseTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseConfiguration()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(_ placeHolder: String) {
        self.init(frame: .zero)
        self.placeholder = placeHolder
    }
    
    convenience init(text: String) {
        self.init(frame: .zero)
        self.text = text
    }
    
    private let padding = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)

    override  func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.padding)
    }


    override  func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.padding)
    }
    

    private func baseConfiguration() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = .label
        self.font = ThemeFont.defaultTheme.text
        self.returnKeyType = .done
        self.borderStyle = .none
        self.card()
    }
}
