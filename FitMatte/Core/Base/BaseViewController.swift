//
//  BaseViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 7.10.2025.
//
import Combine
import UIKit

@MainActor
class BaseViewController<VM: BaseViewModel>: UIViewController {
    let viewModel: VM
    var cancellables = Set<AnyCancellable>()

    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureSubViews()
        addSubViews()
        configureConstraints()
        setupBindings()
        viewModel.viewDidLoad()
    }

    func configureVC() {
        view.backgroundColor = .systemBackground
    }

    func configureSubViews() {}

    func addSubViews() {}

    func configureConstraints() {}

    func setupBindings() {
        // Base state handling
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self else { return }
                self.handleState(state)
            }
            .store(in: &cancellables)
    }

    func handleState(_ state: ViewModelState) {
        switch state {
        case .loading:
            showLoading()
        case .error(let msg):
            showError(msg)
        default:
            hideLoading()
        }
    }

    private func showLoading() {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        indicator.startAnimating()
        indicator.tag = 999
        view.addSubview(indicator)
    }

    private func hideLoading() {
        view.viewWithTag(999)?.removeFromSuperview()
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}
