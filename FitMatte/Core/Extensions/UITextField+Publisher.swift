//
//  UITextField+Publisher.swift
//  FitMatte
//
//  Created by Emre Simsek on 7.10.2025.
//
import Combine
import UIKit

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .receive(on: RunLoop.main)
            .prepend(self.text ?? "")
            .eraseToAnyPublisher()
    }
}
