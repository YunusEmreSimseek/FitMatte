//
//  BaseSection.swift
//  FitMatte
//
//  Created by Emre Simsek on 15.10.2025.
//
import UIKit

protocol BaseSectionProtocol {
    var rows: [BaseSectionRowProtocol] { get }
    var title: String? { get }
    var footer: UIView? { get }
    var header: UIView? { get }
}

struct BaseSection: BaseSectionProtocol {
    var rows: [BaseSectionRowProtocol]
    var title: String?
    var footer: UIView?
    var header: UIView?

    init(
        _ rows: [BaseSectionRowProtocol],
        title: String? = nil,
        header: UIView? = nil,
        footer: UIView? = nil
    ) {
        self.rows = rows
        self.title = title
        self.header = header
        self.footer = footer
    }
}
