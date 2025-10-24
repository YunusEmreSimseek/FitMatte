//
//  BaseTableCell.swift
//  FitMatte
//
//  Created by Emre Simsek on 10.10.2025.
//
import UIKit

class BaseTableCell<View: UIView>: UITableViewCell, ConfigurableCell {
    typealias ConfigurationView = View
    typealias ConfigurationCell = BaseTableCell<View>
    private var view: View = .init()
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        view = .init()
        setupCell()
    }

    final func configureCell(_ configuration: @escaping (BaseTableCell<View>) -> Void) {
        configuration(self)
    }

    final func configureView(_ configuration: @escaping (View) -> Void) {
        configuration(view)
    }

    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        bottomConstraint = view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        leadingConstraint = view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        trailingConstraint = view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)

        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint].compactMap { $0 })
    }
}

extension BaseTableCell {
    func allPadding(_ value: CGFloat) {
        topConstraint?.constant = value
        bottomConstraint?.constant = -value
        leadingConstraint?.constant = value
        trailingConstraint?.constant = -value
    }

    func horizontalPadding(_ value: CGFloat) {
        leadingConstraint?.constant = value
        trailingConstraint?.constant = -value
    }

    func verticalPadding(_ value: CGFloat) {
        topConstraint?.constant = value
        bottomConstraint?.constant = -value
    }

    func topPadding(_ value: CGFloat) {
        topConstraint?.constant = value
    }

    func bottomPadding(_ value: CGFloat) {
        bottomConstraint?.constant = -value
    }

    func leadingPadding(_ value: CGFloat) {
        leadingConstraint?.constant = value
    }

    func trailingPadding(_ value: CGFloat) {
        trailingConstraint?.constant = -value
    }
}
