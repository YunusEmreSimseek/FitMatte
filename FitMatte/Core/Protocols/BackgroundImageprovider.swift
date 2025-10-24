//
//  BackgroundImageprovider.swift
//  FitMatte
//
//  Created by Emre Simsek on 13.10.2025.
//
import UIKit

protocol BackgroundImageProvider: UIViewController {
    var backgroundImageView: UIImageView { get }
    func setupBackgroundImageConstraints()
}

extension BackgroundImageProvider {
    var backgroundImageView: UIImageView {
        if let existingView = view.viewWithTag(999) as? UIImageView {
            return existingView
        } else {
            let imageView = UIImageView()
            imageView.tag = 999
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            return imageView
        }
    }

    func setupBackgroundImageConstraints() {
        let bgView = backgroundImageView
        view.insertSubview(bgView, at: 0)
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: view.topAnchor),
            bgView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
