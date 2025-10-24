//
//  ThemeFont.swift
//  FitMatte
//
//  Created by Emre Simsek on 7.10.2025.
//
import Foundation
import UIKit

struct ThemeFont {
    /// 50 pt and bold
    let veryLargeTitle: UIFont
    
    /// 40 pt and bold
    let largeTitle: UIFont
    
    /// 32 pt and bold
    let highTitle: UIFont

    /// 24 pt and bold
    let boldTitle: UIFont
    /// 24 pt and semi bold
    let semiBoldTitle: UIFont
    /// 24 pt
    let title: UIFont

    /// 20 pt and bold
    let boldSubTitle: UIFont
    /// 20 pt and semi bold
    let semiBoldSubTitle: UIFont
    /// 20 pt
    let subTitle: UIFont

    /// 17 pt and bold
    let boldText: UIFont
    /// 17 pt and semi bold
    let semiBoldText: UIFont
    /// 17 pt
    let text: UIFont

    /// 14 pt and bold
    let boldMediumText: UIFont
    /// 14pt and semi bold
    let semiBoldMediumText: UIFont
    /// 14pt
    let mediumText: UIFont

    /// 12 pt
    let smallText: UIFont
    /// 8 pt
    let verySmallText: UIFont
}

extension ThemeFont {
    static let defaultTheme: ThemeFont = .init(
        veryLargeTitle: .systemFont(ofSize: FontSize.veryLarge.rawValue, weight: .bold),
        largeTitle: .systemFont(ofSize: FontSize.large1.rawValue, weight: .bold),
        highTitle: .systemFont(ofSize: FontSize.large2.rawValue, weight: .bold),
        boldTitle: .systemFont(ofSize: FontSize.large3.rawValue, weight: .bold),
        semiBoldTitle: .systemFont(ofSize: FontSize.large3.rawValue, weight: .semibold),
        title: .systemFont(ofSize: FontSize.large3.rawValue),
        boldSubTitle: .systemFont(ofSize: FontSize.high.rawValue, weight: .bold),
        semiBoldSubTitle: .systemFont(ofSize: FontSize.high.rawValue, weight: .semibold),
        subTitle: .systemFont(ofSize: FontSize.high.rawValue),
        boldText: .systemFont(ofSize: FontSize.default.rawValue, weight: .bold),
        semiBoldText: .systemFont(ofSize: FontSize.default.rawValue, weight: .semibold),
        text: .systemFont(ofSize: FontSize.default.rawValue),
        boldMediumText: .systemFont(ofSize: FontSize.medium.rawValue, weight: .bold),
        semiBoldMediumText: .systemFont(ofSize: FontSize.medium.rawValue, weight: .semibold),
        mediumText: .systemFont(ofSize: FontSize.medium.rawValue),
        smallText: .systemFont(ofSize: FontSize.small.rawValue),
        verySmallText: .systemFont(ofSize: FontSize.verySmall.rawValue)
    )
}

enum FontSize: CGFloat {
    case verySmall = 8
    case small = 12
    case medium = 14
    case `default` = 17
    case high = 20
    case large3 = 24
    case large2 = 32
    case large1 = 40
    case veryLarge = 50
}
