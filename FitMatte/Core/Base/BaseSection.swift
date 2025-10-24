//
//  BaseSection.swift
//  FitMatte
//
//  Created by Emre Simsek on 15.10.2025.
//


protocol BaseSectionProtocol {
    var rows: [BaseSectionRowProtocol] { get }
    var title: String? { get }
}

struct BaseSection: BaseSectionProtocol {
    var rows: [BaseSectionRowProtocol]
    var title: String?

    init(_ rows: [BaseSectionRowProtocol], title: String? = nil) {
        self.rows = rows
        self.title = title
    }
}
