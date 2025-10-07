//
//  BaseViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 7.10.2025.
//
import UIKit

/// Base ViewController Protocol
protocol BaseViewControllerProtocol: AnyObject {
    var viewModel: BaseViewModelProtocol { get }
    func configureVC()
    func configureSubViews()
    func addSubViews()
    func configureConstraints()
}

/// Base ViewController
class BaseViewController: UIViewController, BaseViewControllerProtocol {
    let viewModel: BaseViewModelProtocol

    init(viewModel: BaseViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }

    func configureSubViews() {}

    func addSubViews() {}

    func configureConstraints() {}

    func configureVC() {}
}
