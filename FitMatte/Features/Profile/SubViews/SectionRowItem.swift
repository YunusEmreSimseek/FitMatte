//
//  SectionRowItem.swift
//  FitMatte
//
//  Created by Emre Simsek on 16.10.2025.
//
import UIKit

final class SectionRowItem: UIStackView {
    init(icon: String, title: String) {
        super.init(frame: .zero)
        self.baseConfiguration(icon, title)
    }

    init(icon: String, title: String, value: String, showLink: Bool = true) {
        super.init(frame: .zero)
        self.baseConfigurationWithValue(icon, title, value, showLink)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func baseConfiguration(_ icon: String, _ title: String) {
        let iconImageView: UIView = createIconImageView(icon)
        let titleLabel = createTitleLabel(title)
        let linkButton = createLinkButton()
        configureSelf([iconImageView, titleLabel, UIView(), linkButton])
    }

    private func baseConfigurationWithValue(_ icon: String, _ title: String, _ value: String, _ showLink: Bool = true) {
        let iconImageView: UIView = createIconImageView(icon)
        let titleLabel = createTitleLabel(title)
        let valueLabel = createValueLabel(value)
        let linkButton = createLinkButton()
        if showLink {
            let hStack = createHStack([valueLabel, linkButton])
            configureSelf([iconImageView, titleLabel, UIView(), hStack])
        }
        else {
            configureSelf([iconImageView, titleLabel, UIView(), valueLabel])
        }
    }
}

extension SectionRowItem {
    private func createIconImageView(_ icon: String) -> UIView {
        let containerView = UIView()
        let imageView = UIImageView(image: .init(systemName: icon))
        imageView.contentMode = .scaleAspectFill
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        containerView.addSubview(imageView)
        imageView.fillSuperview(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        containerView.card()
        return containerView
    }

    private func createTitleLabel(_ title: String) -> BaseLabel {
        BaseLabel(title, ThemeFont.defaultTheme.mediumText)
    }

    private func createLinkButton() -> UIButton {
        let button = UIButton(type: .system)
        button.configuration = .plain()
        button.configuration?.image = .init(systemName: "chevron.right")
        button.configuration?.preferredSymbolConfigurationForImage = .init(font: .systemFont(ofSize: 12))
        button.configuration?.contentInsets = .zero
        return button
    }

    private func createValueLabel(_ value: String) -> BaseLabel {
        let valueLabel = BaseLabel(value)
        valueLabel.font = ThemeFont.defaultTheme.mediumText
        valueLabel.textColor = .secondaryLabel
        return valueLabel
    }

    private func createHStack(_ items: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: items)
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }

    private func configureSelf(_ items: [UIView]) {
        self.axis = .horizontal
        self.alignment = .center
        self.spacing = 12
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        for item in items {
            self.addArrangedSubview(item)
        }
    }
}
