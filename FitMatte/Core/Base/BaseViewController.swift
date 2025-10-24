//
//  BaseViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 10.10.2025.
//
import Combine
import UIKit

class BaseViewController<VM: BaseViewModel>: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var tableView = UITableView(frame: .zero, style: .grouped)
    let viewModel: VM
    private var sections: [BaseSection] = []
    private var registeredReuseIds = Set<String>()
    var cancellables = Set<AnyCancellable>()
    private lazy var loadingView: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: .large)
        v.hidesWhenStopped = true
        return v
    }()
    private var tableViewBottomConstraint: NSLayoutConstraint?
    private let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addAction(UIAction{ _ in
            print("Refresh triggered")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    rc.endRefreshing()
                }
            }, for: .valueChanged)
        return rc
    }()

    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupTableView()
//        setupRefreshControl()
        setupBindings()
        registerDynamicBackgroundColor()
        setBackgroundColor()
    }

    func registerDynamicBackgroundColor() {
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
            self.setBackgroundColor()
        }
    }
    
    func setTableHeight(_ height: CGFloat) {
        tableView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setRefreshAction(_ action: UIAction) {
        refreshControl.addAction(action, for: .valueChanged)
    }

    func setBackgroundColor() {
        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .secondarySystemBackground
        } else {
            view.backgroundColor = .systemBackground
        }
    }

    func changeTableStyle(_ style: UITableView.Style) {
        tableView.removeFromSuperview()
        tableView = UITableView(frame: .zero, style: style)
        setupTableView()
    }

    func changeTableSeparatorStyle(_ style: UITableViewCell.SeparatorStyle) {
        tableView.separatorStyle = style
    }

    func cleanTable() {
        sections.removeAll()
        registeredReuseIds.removeAll()
        tableView.reloadData()
    }

    func reloadUI() {
        tableView.reloadData()
    }

    func setRowHeight(_ height: CGFloat) {
        tableView.rowHeight = height
    }

    func addAllPadding(_ padding: CGFloat = 16) {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            tableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -padding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding)
        ])
    }

    func addFooterView(_ view: UIView) {
        self.view.addSubview(view)
        tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor, constant: -80)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
    }

    func addSection(_ rows: [BaseSectionRowProtocol], title: String? = nil) {
        let section = BaseSection(rows, title: title)
        sections.append(section)
        setupUI()
    }

    func setupUI(animated: Bool = false) {
        guard !sections.isEmpty else { return }

        sections.flatMap { $0.rows }.forEach { row in
            if registeredReuseIds.insert(row.reuseId).inserted {
                row.register(on: tableView)
            }
        }

        if animated {
            tableView.performBatchUpdates({
                tableView.reloadSections(IndexSet(integersIn: 0 ..< max(1, sections.count)), with: .automatic)
            }, completion: nil)
        } else {
            tableView.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sections.indices.contains(section) else { return 0 }
        return sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard sections.indices.contains(section) else { return nil }
        return sections[section].title
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
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
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.cornerConfiguration = .corners(radius: 0)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableViewBottomConstraint  = tableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -12)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableViewBottomConstraint ?? tableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -12),
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
            tableView.isUserInteractionEnabled = false
        }
    }

    private func hideLoading() {
        loadingView.stopAnimating()
        tableView.isUserInteractionEnabled = true
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
