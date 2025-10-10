//
//  BaseViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 10.10.2025.
//
import UIKit
import Combine

class BaseViewController<VM: BaseViewModel>: UIViewController, UITableViewDataSource, UITableViewDelegate {
     let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let viewModel: VM
    private var sections: [BaseSection] = []
    private var registeredReuseIds = Set<String>()
    var cancellables = Set<AnyCancellable>()
    private lazy var loadingView: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: .large)
        v.hidesWhenStopped = true
        return v
    }()

    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        setupBindings()
    }

    func setupUI(_ sections: [BaseSection], animated: Bool = false) {
        sections.flatMap { $0.rows }.forEach { row in
            if registeredReuseIds.insert(row.reuseId).inserted {
                row.register(on: tableView)
            }
        }

        self.sections = sections

        if animated {
            tableView.performBatchUpdates({
                tableView.reloadSections(IndexSet(integersIn: 0 ..< max(1, sections.count)), with: .automatic)
            }, completion: nil)
        } else {
            tableView.reloadData()
        }
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return max(sections.count, 1)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sections.indices.contains(section) else { return 0 }
        return sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard sections.indices.contains(section) else { return nil }
        return sections[section].title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sections[indexPath.section].rows[indexPath.row]
        return row.dequeueAndConfigure(from: tableView, at: indexPath)
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sections[indexPath.section].rows[indexPath.row].didSelect()
    }

    func setupBindings() {
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
    
    
}

extension BaseViewController {
    private func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func showLoading() {
        if loadingView.superview == nil {
            view.addSubview(loadingView)
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            loadingView.startAnimating()
        }
    }

    private func hideLoading() {
        loadingView.stopAnimating()
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}


extension UITableViewCell {
    func of<T: UITableViewCell>(_ type: T.Type) -> T? { self as? T }
}

