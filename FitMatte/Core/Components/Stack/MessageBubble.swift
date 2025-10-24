//
//  MessageBubble.swift
//  FitMatte
//
//  Created by Emre Simsek on 16.10.2025.
//
import UIKit

final class MessageBubble: UIStackView {
    func configureForUserMessage(message: MessageModel, userName: String) {
        self.axis = .vertical
        self.spacing = 4
        self.alignment = .trailing
        
        let titleLabel = createTitleLabel(userName)
        titleLabel.textAlignment = .right
        let messageCard = createMessageCard(message.text)
        messageCard.backgroundColor = .systemBlue.withAlphaComponent(0.7)
        let imageView = createImageView("person")
        let hStack = createHStack([imageView, messageCard])
        
        self.addArrangedSubview(titleLabel)
        self.addArrangedSubview(hStack)
    }
    
    func configureForAIMessage(_ message: MessageModel) {
        self.axis = .vertical
        self.spacing = 4
        self.alignment = .leading
        
        let titleLabel = createTitleLabel("FitMate")
        let messageCard = createMessageCard(message.text)
        let imageView = createImageView("wind")
        let hStack = createHStack([messageCard, imageView])
        
        self.addArrangedSubview(titleLabel)
        self.addArrangedSubview(hStack)
    }
}

extension MessageBubble {
    private func createTitleLabel(_ text: String) -> BaseLabel {
        let label = BaseLabel(text)
        label.font = ThemeFont.defaultTheme.smallText
        label.textColor = .systemGray
        return label
    }

    private func createMessageCard(_ text: String) -> UIView {
        let label = BaseLabel(text, ThemeFont.defaultTheme.mediumText)
        let container = UIView()
        container.addSubview(label)
        label.fillSuperview(padding: 16)
        container.card()
        return container
    }

    private func createImageView(_ imageName: String) -> UIStackView {
        let imageView = UIImageView()
        imageView.image = .init(systemName: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        let stack = UIStackView(arrangedSubviews: [UIView(), imageView])
        stack.axis = .vertical
        return stack
    }
    
    private func createHStack(_ items: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: items)
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }
}
