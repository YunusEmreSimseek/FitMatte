//
//  ThemeFont.swift
//  FitMatte
//
//  Created by Emre Simsek on 7.10.2025.
//
import Foundation
import UIKit

struct ThemeFont {
    let largeTitleFont: UIFont
    let boldTitleFont: UIFont
    let titleFont: UIFont
    let boldTextFont: UIFont
    let textFont: UIFont
    let smallTextFont: UIFont
    let verySmallTextFont: UIFont
}

extension ThemeFont {
    static let defaultTheme: ThemeFont = .init(
        largeTitleFont: .boldSystemFont(ofSize: FontSize.veryLarge.rawValue),
        boldTitleFont: .boldSystemFont(ofSize: FontSize.large3.rawValue),
        titleFont: .systemFont(ofSize: FontSize.large3.rawValue),
        boldTextFont: .boldSystemFont(ofSize: FontSize.medium.rawValue),
        textFont: .systemFont(ofSize: FontSize.medium.rawValue),
        smallTextFont: .systemFont(ofSize: FontSize.small.rawValue),
        verySmallTextFont: .systemFont(ofSize: FontSize.verySmall.rawValue)
    )
}

enum FontSize: CGFloat {
    case verySmall = 8
    case small = 12
    case medium = 16
    case large3 = 24
    case large2 = 32
    case large1 = 40
    case veryLarge = 50
}
